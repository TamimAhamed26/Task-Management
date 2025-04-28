import { Controller, Get, Query, Res } from '@nestjs/common';
import { Response } from 'express';
import { ProgressService } from './progress.service';
import { ProgressReportDto } from './dto/ProgressReportDto';
import { Roles } from '../auth/decorators/roles.decorator'; 
import { Task } from 'src/entities/task.entity';

@Controller('progress')
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get('weekly-report')
  @Roles('MANAGER')
  async getWeeklyReport(): Promise<ProgressReportDto > {
    return this.progressService.generateWeeklyReport();
  }

  @Get('monthly-report')
@Roles('MANAGER')
async getMonthlyReport(): Promise<ProgressReportDto  > {
  return this.progressService.generateMonthlyReport();
}
@Get('search')
@Roles('MANAGER')
async searchTasksByDate(
  @Query('startDate') startDate: string,
  @Query('endDate') endDate: string,
  @Query('sort') sort: 'ASC' | 'DESC' = 'ASC',
  @Query('page') page = 1,
  @Query('limit') limit = 10,
): Promise<{ data: Task[]; total: number; page: number; limit: number }> {
  return this.progressService.searchTasksByDate(
    startDate,
    endDate,
    sort,
    Number(page),
    Number(limit),
  );
}

@Get('download-weekly-report-pdf')
@Roles('MANAGER')
async downloadWeeklyReportPDF(@Res() res: Response) {
  const pdfBuffer = await this.progressService.generateWeeklyReportPDF();

  res.set({
    'Content-Type': 'application/pdf',
    'Content-Disposition': 'attachment; filename=weekly_report.pdf',
    'Content-Length': pdfBuffer.length,
  });

  res.send(pdfBuffer);
}



}
