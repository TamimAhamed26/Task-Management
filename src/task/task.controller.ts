import { 
    Controller, 
    Get, 
    Patch, 
    Delete, 
    Param, 
    Body, 
    ParseIntPipe 
  } from '@nestjs/common';
  import { TaskService } from './task.service';
  import { Task } from '../entities/task.entity';
  import { GetUser } from '../auth/decorators/get-user.decorator';
  import { User } from '../entities/user.entity';
  import { EditTaskDto } from './dto/edit-task.dto';
  import { Roles } from '../auth/decorators/roles.decorator'; 

  @Controller('tasks')
  export class TaskController {
    constructor(private readonly taskService: TaskService) {}
  
    @Get('pending')
    @Roles('MANAGER') 
    async getPendingTasks(): Promise<Task[]> {
      return this.taskService.getPendingTasks();
    }
  
    @Patch(':id/approve')
    @Roles('MANAGER') 
    async approveTask(
      @Param('id', ParseIntPipe) id: number,
      @GetUser() manager: User,
    ): Promise<Task> {
      return this.taskService.approveTask(id, manager);
    }
  
    @Patch(':id')
    @Roles('MANAGER') 
    async editTask(
      @Param('id', ParseIntPipe) id: number,
      @Body() updates: EditTaskDto,
    ): Promise<Task> {
      return this.taskService.editTask(id, updates);
    }
  
    @Delete(':id')
    @Roles('MANAGER') 
    async rejectTask(
      @Param('id', ParseIntPipe) id: number,
    ): Promise<{ message: string }> {
      await this.taskService.rejectTask(id);
      return { message: 'Task rejected and deleted successfully' };
    }
  }