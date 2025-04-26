// src/task/dto/edit-task.dto.ts

import { IsOptional, IsString, IsEnum, IsDateString, IsBoolean } from 'class-validator';
import { PriorityLevel, TaskStatus } from 'src/entities/task.entity';


export class EditTaskDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsEnum(TaskStatus)
  status?: TaskStatus;

  @IsOptional()
  @IsEnum(PriorityLevel)
  priority?: PriorityLevel;

  @IsOptional()
  @IsString()
  category?: string;

  @IsOptional()
  @IsDateString()
  dueDate?: Date;

  @IsOptional()
  @IsBoolean()
  isCompleted?: boolean;
}
