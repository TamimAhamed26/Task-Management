import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Task, TaskStatus } from '../entities/task.entity';
import { User } from '../entities/user.entity';

@Injectable()
export class TaskService {
  constructor(
    @InjectRepository(Task)
    private readonly taskRepository: Repository<Task>,
  ) {}

  
  private validateAssignedToCollaborator(task: Task) {
    if (!task.assignedTo) {
      throw new BadRequestException('Task must be assigned to a user before approval.');
    }
    if (task.assignedTo.role?.id !== 3) { 
      throw new BadRequestException('Task can only be assigned to a Collaborator.');
    }
  }

  
  async getPendingTasks(): Promise<Task[]> {
    return this.taskRepository.find({
      where: { status: TaskStatus.PENDING },
      relations: ['createdBy', 'assignedTo', 'approvedBy'], 
    });
  }

  // ✅ 2. Approve a pending task
  async approveTask(taskId: number, manager: User): Promise<Task> {
    const task = await this.taskRepository.findOne({
      where: { id: taskId },
      relations: ['createdBy', 'assignedTo', 'assignedTo.role'], 
    });

    if (!task || task.status !== TaskStatus.PENDING) {
      throw new NotFoundException('Pending task not found.');
    }

    this.validateAssignedToCollaborator(task);

    task.status = TaskStatus.APPROVED;
    task.approvedBy = manager;

    return this.taskRepository.save(task);
  }


  async editTask(taskId: number, updates: Partial<Task>): Promise<Task> {
    const task = await this.taskRepository.findOne({
      where: { id: taskId },
      relations: ['assignedTo', 'assignedTo.role'],
    });
  
    if (!task) {
      throw new NotFoundException('Task not found.');
    }
  
    // If client sends a new assignedTo user
    if (updates.assignedTo) {
      const assignedUserId = typeof updates.assignedTo === 'object' ? updates.assignedTo.id : updates.assignedTo;
      
      const assignedUser = await this.taskRepository.manager.findOne(User, {
        where: { id: assignedUserId },
        relations: ['role'],
      });
    
      if (!assignedUser) {
        throw new BadRequestException('Assigned user not found.');
      }
    
      if (assignedUser.role?.id !== 3) { 
        throw new BadRequestException('Assigned user must be a Collaborator.');
      }
    
      task.assignedTo = assignedUser; 
    }
  
    Object.assign(task, updates);
  
    return this.taskRepository.save(task);
  }
  


  async rejectTask(taskId: number): Promise<void> {
    const task = await this.taskRepository.findOne({
      where: { id: taskId },
    });

    if (!task) {
      throw new NotFoundException('Task not found.');
    }

    await this.taskRepository.remove(task);
  }
}
