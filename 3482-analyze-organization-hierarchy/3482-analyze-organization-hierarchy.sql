# Write your MySQL query statement below
WITH RECURSIVE hierarchy AS (
    -- Step 1: Find levels
    SELECT 
        employee_id,
        employee_name,
        manager_id,
        salary,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT 
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        h.level + 1
    FROM Employees e
    JOIN hierarchy h 
        ON e.manager_id = h.employee_id
),

subtree AS (
    -- Step 2: Build subtree (who reports under whom)
    SELECT 
        employee_id AS manager_id,
        employee_id AS emp_id
    FROM Employees

    UNION ALL

    SELECT 
        s.manager_id,
        e.employee_id
    FROM subtree s
    JOIN Employees e 
        ON e.manager_id = s.emp_id
),

aggregation AS (
    -- Step 3: Compute team size and budget
    SELECT 
        s.manager_id AS employee_id,
        COUNT(s.emp_id) - 1 AS team_size,
        SUM(e.salary) AS budget
    FROM subtree s
    JOIN Employees e 
        ON s.emp_id = e.employee_id
    GROUP BY s.manager_id
)

SELECT 
    h.employee_id,
    h.employee_name,
    h.level,
    a.team_size,
    a.budget
FROM hierarchy h
left JOIN aggregation a 
    ON h.employee_id = a.employee_id
ORDER BY 
    h.level ASC,
    a.budget DESC,
    h.employee_name ASC;