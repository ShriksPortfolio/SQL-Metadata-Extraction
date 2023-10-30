
DECLARE @StartDate DATE = GETDATE()

SELECT 
	EOMONTH(@StartDate) EndOfMonth,				-- Current END of MONTH
	EOMONTH(@StartDate, -1) EndOfMonth_Prev,	-- go back one month
	EOMONTH(@StartDate, 1)  EndOfMonth_Next		-- go forward a month
