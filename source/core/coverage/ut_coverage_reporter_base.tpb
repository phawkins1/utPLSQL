create or replace type body ut_coverage_reporter_base is
  /*
  utPLSQL - Version 3
  Copyright 2016 - 2019 utPLSQL Project

  Licensed under the Apache License, Version 2.0 (the "License"):
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  */

  overriding final member procedure before_calling_run(self in out nocopy ut_coverage_reporter_base, a_run ut_run) as
  begin
    (self as ut_output_reporter_base).before_calling_run(a_run);
    ut_coverage.coverage_start(a_coverage_run_id => a_run.coverage_options.coverage_run_id);
  end;

  overriding final member procedure before_calling_before_all(self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
    ut_coverage.coverage_resume();
  end;
  overriding final member procedure after_calling_before_all (self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
      ut_coverage.coverage_pause();
  end;

  overriding final member procedure before_calling_before_each(self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
    ut_coverage.coverage_resume();
  end;
  overriding final member procedure after_calling_before_each (self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
      ut_coverage.coverage_pause();
  end;

  overriding final member procedure before_calling_before_test(self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
    ut_coverage.coverage_resume();
  end;
  overriding final member procedure after_calling_before_test (self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
      ut_coverage.coverage_pause();
  end;

  overriding final member procedure before_calling_test_execute(self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
    ut_coverage.coverage_resume();
  end;
  overriding final member procedure after_calling_test_execute (self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
      ut_coverage.coverage_pause();
  end;

  overriding final member procedure before_calling_after_test(self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
    ut_coverage.coverage_resume();
  end;
  overriding final member procedure after_calling_after_test (self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
      ut_coverage.coverage_pause();
  end;

  overriding final member procedure before_calling_after_each(self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
    ut_coverage.coverage_resume();
  end;
  overriding final member procedure after_calling_after_each (self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
      ut_coverage.coverage_pause();
  end;

  overriding final member procedure before_calling_after_all(self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
    ut_coverage.coverage_resume();
  end;
  overriding final member procedure after_calling_after_all (self in out nocopy ut_coverage_reporter_base, a_executable in ut_executable) is
  begin
      ut_coverage.coverage_pause();
  end;

  final member function get_report( a_coverage_options ut_coverage_options ) return ut_output_data_rows pipelined is
    reporter ut_coverage_reporter_base := self;
  begin
    reporter.after_calling_run( ut_run( a_coverage_options => a_coverage_options ) );

    for i in (select value(x) val from table(self.output_buffer.get_lines(1, 1)) x ) loop
      pipe row (i.val);
    end loop;
  end;

  final member function get_report_cursor( a_coverage_options ut_coverage_options ) return sys_refcursor is
    reporter ut_coverage_reporter_base := self;
  begin
    reporter.after_calling_run( ut_run( a_coverage_options => a_coverage_options ) );
    return self.output_buffer.get_lines_cursor(1, 1);
  end;

end;
/
