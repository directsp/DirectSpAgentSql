
-- Create common exception
CREATE PROC dsp.Init_@createCommonExceptions
AS
BEGIN

	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_general(), N'General');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_accessDeniedOrObjectNotExists(), N'AccessDeniedOrObjectNotExists');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_objectAlreadyExists(), N'ObjectAlreadyExists');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_objectIsInUse(), N'ObjectIsInUse');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_pageSizeTooLarge(), N'PageSizeTooLarge');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_invalidArgument(), N'InvalidArgument');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_fatalError(), N'FatalError');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_validationError(), N'ValidationError');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_notSupported(), N'NotSupported');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_notImplemented(), N'NotImplemented');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_userIsDisabled(), N'UserIsDisabled');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_ambiguous(), N'Ambiguous');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_noOperation(), N'NoOperation');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_invalidCaptcha(), N'InvalidCaptcha');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_batchIsNotAllowed(), N'BatchIsNotAllowed');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_tooManyRequest(), N'TooManyRequest');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_authUserNotFound(), N'AuthUserNotFound');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_invokerAppVersion(), N'InvokerAppVersion');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_maintenance(), N'Maintenance');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_maintenanceReadOnly(), N'MaintenanceReadOnly');
	INSERT dsp.Exception ([exceptionId], [exceptionName]) VALUES (dsp.ExceptionId_invalidParamSignature(), N'InvalidParamSignature');

END