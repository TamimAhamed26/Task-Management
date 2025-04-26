import {
  Injectable,
  NotFoundException,
  BadRequestException,
   ForbiddenException
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UpdatePasswordDto } from './dto/update-password.dto';
import { FileService } from '../file/file.service'; // Import FileService 

@Injectable()
export class UserService {

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>, // Inject FileService here
    private readonly fileService: FileService,  // Inject FileService here


  ) {}

  async findById(id: number): Promise<User> {
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    return user;
  }


  async updateProfile(id: number, updateDto: UpdateProfileDto): Promise<string> {
      const user = await this.findById(id);
  
      // Check for any invalid fields in the update
      const allowedFields = ['username', 'email', 'phone'];
      const updateKeys = Object.keys(updateDto);
  
      // If any key is not part of the allowed fields, throw an error
      const invalidFields = updateKeys.filter(key => !allowedFields.includes(key));
      if (invalidFields.length > 0) {
          throw new ForbiddenException('Not permitted to update these fields, please use other routes.');
      }
  
      Object.assign(user, updateDto);
      await this.userRepository.save(user);
      return 'Profile updated successfully';
  }
  

  async updatePassword(id: number, dto: UpdatePasswordDto): Promise<string> {
    const user = await this.findById(id);

    if (Object.keys(dto).length !== 2) { 
        throw new ForbiddenException('Not permitted to update these fields, please use other routes.');
    }

    if (user.password !== dto.currentPassword) {
        throw new BadRequestException('Current password is incorrect');
    }

    user.password = dto.newPassword;
    await this.userRepository.save(user);
    return 'Password updated successfully';
}

async updateAvatar(id: number, avatarData: string | Express.Multer.File): Promise<User> {
  const user = await this.findById(id);
  if (!user) {
    throw new BadRequestException('User not found');
  }

  if (avatarData && (avatarData as Express.Multer.File).buffer) {

    const fileName = await this.fileService.uploadFile(avatarData as Express.Multer.File);

    user.avatarUrl = `http://localhost:3000/uploads/${fileName}`;
  } else if (typeof avatarData === 'string' && avatarData.startsWith('http')) {
    user.avatarUrl = avatarData;
  } else {
    throw new ForbiddenException('Invalid avatar data');
  }

  return this.userRepository.save(user);
}

  
  async getDashboardStats(id: number): Promise<any> {
    const user = await this.findById(id);
    return {
      message: `Welcome ${user.username}`,
      quickActions: ['Edit Profile', 'View Notifications', 'Check Activity Log'],
      stats: {
        tasksCompleted: 12,
        notifications: 3,
        role: user.role.name,
      },
    };
  }
}
