/*
	https://msdn.microsoft.com/en-us/library/ms189747.aspx
	Both queries below come directly from examples on MSDN.com. 
	To get more detailed information check out the link above.
*/

-- ACTUAL CACHED EXECUTION PLANS:

USE master;
GO
SELECT * 
FROM sys.dm_exec_cached_plans cp 
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle);
GO


-- Retrieve information about the top five queries by average CPU time.
-- The below query returns the XML plan which can be saved and showed in graphical plan format.

SELECT TOP 5	
	total_worker_time/execution_count AS [Avg CPU Time],
	Plan_handle, 
	query_plan 
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle)
ORDER BY total_worker_time/execution_count DESC;
GO
