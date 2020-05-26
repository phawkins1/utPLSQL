create or replace type body ut_be_within is
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

  member procedure init(self in out nocopy ut_be_within, a_amt number, a_pct number, a_expected ut_data_value) is
  begin
    self.self_type       := $$plsql_unit;
    self.a_amt     := a_amt;
    self.a_pct     := a_pct;
    self.expected  := a_expected;
  end;

  constructor function ut_be_within(self in out nocopy ut_be_within, a_amt number,a_pct number := 0, a_expected number)
    return self as result is
  begin
    init(a_amt,a_pct, ut_data_value_number(a_expected));
    return;
  end;
  
  constructor function ut_be_within(self in out nocopy ut_be_within, a_amt number)
    return self as result is
  begin
    self.a_amt     := a_amt;
    return;
  end;  
  
  constructor function ut_be_within(self in out nocopy ut_be_within, a_amt number,a_pct number := 0, a_expected date)
    return self as result is
  begin
    init(a_amt,a_pct, ut_data_value_date(a_expected));
    return;
  end;
  
  constructor function ut_be_within(self in out nocopy ut_be_within, a_amt number,a_pct number := 0, a_expected timestamp_unconstrained)
    return self as result is
  begin
    init(a_amt,a_pct, ut_data_value_timestamp(a_expected));
    return;
  end;
  
  constructor function ut_be_within(self in out nocopy ut_be_within, a_amt number,a_pct number := 0, a_expected timestamp_tz_unconstrained)
    return self as result is
  begin
    init(a_amt,a_pct, ut_data_value_timestamp_tz(a_expected));
    return;
  end;
  
  constructor function ut_be_within(self in out nocopy ut_be_within, a_amt number,a_pct number := 0, a_expected timestamp_ltz_unconstrained)
    return self as result is
  begin
    init(a_amt,a_pct, ut_data_value_timestamp_ltz(a_expected));
    return;
  end;
  
  constructor function ut_be_within(self in out nocopy ut_be_within, a_amt number,a_pct number := 0, a_expected yminterval_unconstrained)
    return self as result is
  begin
    init(a_amt,a_pct, ut_data_value_yminterval(a_expected));
    return;
  end;

  constructor function ut_be_within(self in out nocopy ut_be_within, a_amt number,a_pct number := 0, a_expected dsinterval_unconstrained)
    return self as result is
  begin
    init(a_amt,a_pct, ut_data_value_dsinterval(a_expected));
    return;
  end;
  
  overriding member function run_matcher(self in out nocopy ut_be_within, a_actual ut_data_value) return boolean is
    l_result boolean;
  begin
    if (self.expected.data_type = a_actual.data_type) then
      if a_actual is of (ut_data_value_number) then
        if a_pct = 0 then
          l_result := abs(self.a_amt) >= treat(expected as ut_data_value_number).data_value - treat(a_actual as ut_data_value_number).data_value;
        else 
          l_result := abs(self.a_amt) <= 100 - ((treat(a_actual as ut_data_value_number).data_value * 100 ) / treat(expected as ut_data_value_number).data_value ) ;
        end if;
      elsif a_actual is of (ut_data_value_date) then
        l_result := abs(self.a_amt) >= treat(expected as ut_data_value_date).data_value - treat(a_actual as ut_data_value_date).data_value;
      elsif a_actual is of (ut_data_value_timestamp) then
        l_result := abs(self.a_amt) >= treat(expected as ut_data_value_timestamp).data_value - treat(a_actual as ut_data_value_timestamp).data_value;
      elsif a_actual is of (ut_data_value_timestamp_tz) then
        l_result := abs(self.a_amt) >= treat(expected as ut_data_value_timestamp_tz).data_value - treat(a_actual as ut_data_value_timestamp_tz).data_value;
      elsif a_actual is of (ut_data_value_timestamp_ltz) then
        l_result := abs(self.a_amt) >= treat(expected as ut_data_value_timestamp_ltz).data_value - treat(a_actual as ut_data_value_timestamp_ltz).data_value; 
      elsif a_actual is of (ut_data_value_yminterval) then
        l_result := abs(self.a_amt) >= treat(expected as ut_data_value_yminterval).data_value - treat(a_actual as ut_data_value_yminterval).data_value;      
      end if;
    else
      l_result := (self as ut_matcher).run_matcher(a_actual);
    end if;      
    return l_result;
  end;

  member function of_(a_expected number) return ut_be_within is
    l_result ut_be_within := self;
  begin
    l_result.expected := ut_data_value_number(a_expected);
    return l_result;
  end;

  overriding member function failure_message(a_actual ut_data_value) return varchar2 is
  begin
    return (self as ut_matcher).failure_message(a_actual)|| case when a_pct = 0 then ' absolute distance of '||self.a_amt  else ' '|| self.a_amt|| ' percent'  end || ' from '||expected.to_string_report();
  end;

  overriding member function failure_message_when_negated(a_actual ut_data_value) return varchar2 is
  begin
    return (self as ut_matcher).failure_message_when_negated(a_actual);
  end;

end;
/
