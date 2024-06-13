{%MainUnit TestFramework.pas}

{$IFDEF read_interface}

  procedure AssertTrue(const AMessage: string; ACondition: boolean; AErrorAddrs: Pointer = nil); overload;
  procedure AssertTrue(ACondition: boolean); overload;
  procedure AssertFalse(const AMessage: string; ACondition: boolean; AErrorAddrs: Pointer = nil); overload;
  procedure AssertFalse(ACondition: boolean); overload;
  procedure AssertEquals(const AMessage: string; Expected, Actual: string); overload;
  procedure AssertEquals(Expected, Actual: string); overload;
  {$IFDEF UNICODE}
  //procedure AssertEquals(const AMessage: string; Expected, Actual: UnicodeString); overload;
  //procedure AssertEquals(Expected, Actual: UnicodeString); overload;
  {$ENDIF}
  procedure AssertEquals(const AMessage: string; Expected, Actual: integer); overload;
  procedure AssertEquals(Expected, Actual: integer); overload;
  procedure AssertEquals(const AMessage: string; Expected, Actual: int64); overload;
  procedure AssertEquals(Expected, Actual: int64); overload;
  procedure AssertEquals(const AMessage: string; Expected, Actual: currency); overload;
  procedure AssertEquals(Expected, Actual: currency); overload;
  procedure AssertEquals(const AMessage: string; Expected, Actual, Delta: double); overload;
  procedure AssertEquals(Expected, Actual, Delta: double); overload;
  procedure AssertEquals(const AMessage: string; Expected, Actual: boolean); overload;
  procedure AssertEquals(Expected, Actual: boolean); overload;
  //procedure AssertEquals(const AMessage: string; Expected, Actual: char); overload;
  //procedure AssertEquals(Expected, Actual: char); overload;
  procedure AssertEquals(const AMessage: string; Expected, Actual: TClass); overload;
  procedure AssertEquals(Expected, Actual: TClass); overload;
  procedure AssertSame(const AMessage: string; Expected, Actual: TObject); overload;
  //procedure AssertSame(Expected, Actual: TObject); overload;
  //procedure AssertSame(const AMessage: string; Expected, Actual: Pointer); overload;
  //procedure AssertSame(Expected, Actual: Pointer); overload;
  //procedure AssertNotSame(const AMessage: string; Expected, Actual: TObject); overload;
  //procedure AssertNotSame(Expected, Actual: TObject); overload;
  //procedure AssertNotSame(const AMessage: string; Expected, Actual: Pointer); overload;
  //procedure AssertNotSame(Expected, Actual: Pointer); overload;
  procedure AssertNotNull(const AMessage: string; AObject: TObject); overload;
  procedure AssertNotNull(AObject: TObject); overload;
  //procedure AssertNotNullIntf(const AMessage: string; AInterface: IInterface); overload;
  //procedure AssertNotNullIntf(AInterface: IInterface); overload;
  //procedure AssertNotNull(const AMessage: string; APointer: Pointer); overload;
  //procedure AssertNotNull(APointer: Pointer); overload;
  procedure AssertNull(const AMessage: string; AObject: TObject); overload;
  //procedure AssertNull(AObject: TObject); overload;
  //procedure AssertNullIntf(const AMessage: string; AInterface: IInterface); overload;
  //procedure AssertNullIntf(AInterface: IInterface); overload;
  //procedure AssertNull(const AMessage: string; APointer: Pointer); overload;
  //procedure AssertNull(APointer: Pointer); overload;
  //procedure AssertNotNull(const AMessage, AString: string); overload;
  //procedure AssertNotNull(const AString: string); overload;
  procedure AssertException(const AMessage: string; AExceptionClass: ExceptClass; AMethod: TExceptTestMethod; AExceptionMessage : String = ''; AExceptionContext : Integer = 0; AErrorAddr : Pointer = Nil); overload;
  //procedure AssertException(AExceptionClass: ExceptClass; AMethod: TRunMethod;AExceptionMessage : String = ''; AExceptionContext : Integer = 0); overload;

{$ENDIF read_interface}


{$IFDEF read_implementation}

procedure TTestProc.AssertTrue(const AMessage: string; ACondition: boolean; AErrorAddrs: Pointer);
begin
  OnCheckCalled;
  if (not ACondition) then
      FailNotEquals(BoolToStr(true, true), BoolToStr(false, true), AMessage, CallerAddr);
end;

procedure TTestProc.AssertTrue(ACondition: boolean);
begin
  CheckTrue(ACondition);
end;

procedure TTestProc.AssertFalse(const AMessage: string; ACondition: boolean; AErrorAddrs: Pointer);
begin
  CheckFalse(ACondition, AMessage);
end;

procedure TTestProc.AssertFalse(ACondition: boolean);
begin
  CheckFalse(ACondition);
end;

procedure TTestProc.AssertEquals(const AMessage: string; Expected, Actual: string); overload;
begin
  OnCheckCalled;
  if expected <> actual then
    FailNotEquals(expected, actual, AMessage, CallerAddr);
end;

procedure TTestProc.AssertEquals(Expected, Actual: string); overload;
begin
  OnCheckCalled;
  if expected <> actual then
    FailNotEquals(expected, actual, '', CallerAddr);
end;

procedure TTestProc.AssertEquals(const AMessage: string; Expected, Actual: integer);
begin
  OnCheckCalled;
  if (expected <> actual) then
    FailNotEquals(IntToStr(expected), IntToStr(actual), AMessage, CallerAddr);
end;

procedure TTestProc.AssertEquals(Expected, Actual: integer);
begin
  CheckEquals(Expected, Actual);
end;

procedure TTestProc.AssertEquals(const AMessage: string; Expected, Actual: int64);
begin
  CheckEquals(Expected, Actual, AMessage);
end;

procedure TTestProc.AssertEquals(Expected, Actual: int64);
begin
  CheckEquals(Expected, Actual);
end;

procedure TTestProc.AssertEquals(const AMessage: string; Expected, Actual: currency);
begin
  OnCheckCalled;
  if (abs(expected-actual) > 0) then
    FailNotEquals(FloatToStr(expected), FloatToStr(actual), AMessage, CallerAddr);
end;

procedure TTestProc.AssertEquals(Expected, Actual: currency);
begin
  OnCheckCalled;
  if (abs(expected-actual) > 0) then
    FailNotEquals(FloatToStr(expected), FloatToStr(actual), '', CallerAddr);
end;

procedure TTestProc.AssertEquals(const AMessage: string; Expected, Actual, Delta: double);
begin
  CheckEquals(Expected, Actual, Delta, AMessage);
end;

procedure TTestProc.AssertEquals(Expected, Actual, Delta: double);
begin
  CheckEquals(Expected, Actual, Delta);
end;

procedure TTestProc.AssertEquals(const AMessage: string; Expected, Actual: boolean);
begin
  CheckEquals(Expected, Actual, AMessage);
end;

procedure TTestProc.AssertEquals(Expected, Actual: boolean);
begin
  CheckEquals(Expected, Actual);
end;

procedure TTestProc.AssertEquals(const AMessage: string; Expected, Actual: TClass);
begin
  CheckEquals(Expected, Actual, AMessage);
end;

procedure TTestProc.AssertEquals(Expected, Actual: TClass);
begin
  CheckEquals(Expected, Actual);
end;

procedure TTestProc.AssertSame(const AMessage: string; Expected, Actual: TObject);
begin
  CheckSame(Expected, Actual, AMessage);
end;

procedure TTestProc.AssertNotNull(const AMessage: string; AObject: TObject);
begin
  CheckNotNull(AObject, AMessage);
end;

procedure TTestProc.AssertNotNull(AObject: TObject);
begin
  CheckNotNull(AObject);
end;

procedure TTestProc.AssertNull(const AMessage: string; AObject: TObject);
begin
  CheckNull(AObject, AMessage);
end;

procedure TTestProc.AssertException(const AMessage: string; AExceptionClass: ExceptClass; AMethod: TExceptTestMethod;
  AExceptionMessage: String; AExceptionContext: Integer; AErrorAddr: Pointer);
begin
  CheckException(AMethod, AExceptionClass, AExceptionMessage);
end;


{$ENDIF read_implementation}

