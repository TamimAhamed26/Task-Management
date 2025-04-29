import { IsEmail, IsNotEmpty } from 'class-validator';

export class LoginDto {
  @IsEmail()
  @IsNotEmpty({message:"missing email"})
  email: string;

  @IsNotEmpty()
  
  password: string;
}
