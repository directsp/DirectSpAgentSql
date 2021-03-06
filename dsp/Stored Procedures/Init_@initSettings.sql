﻿CREATE PROC dsp.Init_@initSettings
AS
BEGIN
    SET NOCOUNT ON;

    ----------------
    -- Insert the only dsp.Settings record
    ----------------
    IF (NOT EXISTS (SELECT  1 FROM  dsp.Setting))
    BEGIN
        -- Report it is done
        EXEC dsp.Log_trace @procId = @@PROCID, @message = 'Creating default dsp.Settings';
        INSERT  dsp.Setting (settingId)
        VALUES (1);
    END;

    ----------------
    -- Insert the only dbo.Settings record
    ----------------
    IF (NOT EXISTS (SELECT  1 FROM  dbo.Setting))
    BEGIN
        EXEC dsp.Log_trace @procId = @@PROCID, @message = 'Creating default dbo.Settings';
        INSERT  dbo.Setting ([settingId])
        VALUES (1);
    END;

END;