import {
  Injectable,
  NestMiddleware,
  UnauthorizedException,
} from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Token, TokenType } from '../entities/token.entity';
import { User } from '../entities/user.entity';

@Injectable()
export class RefreshTokenMiddleware implements NestMiddleware {
  constructor(
    private jwtService: JwtService,
    @InjectRepository(Token) private tokenRepo: Repository<Token>,
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

  async use(req: Request, res: Response, next: NextFunction) {
    const authHeader = req.headers['authorization'];
    const accessToken = authHeader?.split(' ')[1];

    console.log('\n [MIDDLEWARE] Checking for access token...');
    console.log('Authorization header:', authHeader);

    if (!accessToken) {
      console.log(' No access token provided');
      return next();
    }

    try {
      // Decode token (even if expired)
      const decoded = this.jwtService.verify(accessToken, {
        secret: 'mysecretkey',
        ignoreExpiration: true,
      });

      console.log(' Access token decoded:', decoded);

      const user = await this.userRepo.findOne({
        where: { id: decoded.sub },
        relations: ['role', 'tokens'],
      });

      if (!user) {
        console.log(' No user found for token sub');
        return next();
      }

      const tokenInDb = user.tokens.find(
        t => t.token === accessToken && t.type === TokenType.ACCESS,
      );

      if (!tokenInDb) {
        console.log(' Token not found in DB for user:', user.id);
        return next();
      }

      const now = Date.now();
      const lastActive = user.lastActiveAt?.getTime() ?? 0;
      const tokenExp = decoded.exp * 1000;

      const sessionExpired = now - lastActive > 30 * 60 * 1000;
      const isNearExpiry = tokenExp - now <= 60 * 1000;

      console.log(` Now: ${new Date(now).toISOString()}`);
      console.log(` Token expiry: ${new Date(tokenExp).toISOString()}`);
      console.log(` Last active: ${new Date(lastActive).toISOString()}`);
      console.log(' Session expired:', sessionExpired);
      console.log(' Token near expiry:', isNearExpiry);

      if (sessionExpired) {
        console.log(' Session expired, deleting token');
        await this.tokenRepo.remove(tokenInDb);
        return next();
      }

      if (isNearExpiry) {
        console.log(' Token near expiry, refreshing token...');

        const newToken = this.jwtService.sign(
          {
            sub: user.id,
            email: user.email,
            role: user.role?.name,
          },
          {
            secret:'mysecretkey',
            expiresIn: '30m',
          },
        );

        const newTokenEntity = this.tokenRepo.create({
          user,
          token: newToken,
          type: TokenType.ACCESS,
        });

        await this.tokenRepo.save(newTokenEntity);
        await this.tokenRepo.remove(tokenInDb);
        res.setHeader('x-access-token', newToken);
        console.log(' New token set in x-access-token header');
        console.log(' New token:', newToken);
      }

      // Update activity
      user.lastActiveAt = new Date();
      await this.userRepo.save(user);

      console.log(' Updated user lastActiveAt');

      return next();
    } catch (err) {
      console.log(' Error verifying or refreshing token:', err.message);
      return next();
    }
  }
}
