
-- Create common exception
CREATE PROC [dsp].[Init_$CreateCommonExceptions]
AS
BEGIN

	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_General(), N'General');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_AccessDeniedOrObjectNotExists(), N'AccessDeniedOrObjectNotExists');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_ObjectAlreadyExists(), N'ObjectAlreadyExists');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_ObjectIsInUse(), N'ObjectIsInUse');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_PageSizeTooLarge(), N'PageSizeTooLarge');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_InvalidArgument(), N'InvalidArgument');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_FatalError(), N'FatalError');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_ValidationError(), N'ValidationError');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_InvalidOperation(), N'InvalidOperation');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_NotSupported(), N'NotSupported');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_NotImplemented(), N'NotImplemented');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_UserIsDisabled(), N'UserIsDisabled');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_Ambiguous(), N'Ambiguous');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_NoOperation(), N'NoOperation');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_InvalidCaptcha(), N'InvalidCaptcha');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_BatchIsNotAllowed(), N'BatchIsNotAllowed');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_TooManyRequest(), N'TooManyRequest');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_AuthUserNotFound(), N'AuthUserNotFound');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_InvokerAppVersion(), N'InvokerAppVersion');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_Maintenance(), N'Maintenance');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_MaintenanceReadOnly(), N'MaintenanceReadOnly');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_InvalidParamSignature(), N'InvalidParamSignature');

END












