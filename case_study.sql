-- Identify where and when the crime happened
select * from evidence where room='CEO Office';


-- Identify where and when the crime happened
SELECT 
    e.employee_id,
    e.name,
    kl.log_id,
    kl.room,
    kl.entry_time,
    kl.exit_time
FROM
    employees e
        INNER JOIN
    keycard_logs kl ON e.employee_id = kl.employee_id
WHERE
    entry_time BETWEEN '2025-10-15 20:00:00' AND '2025-10-15 21:30:00'
    and
    kl.room='CEO Office';
  
  
  
-- Cross-check alibis with actual logs 
SELECT 
    e.name,
    a.claimed_location,
    a.claim_time,
    kl.room AS actual_room,
    kl.entry_time,
    kl.exit_time
FROM alibis a
JOIN keycard_logs kl
    ON a.employee_id = kl.employee_id
   AND a.claim_time BETWEEN kl.entry_time AND kl.exit_time
JOIN employees e
    ON e.employee_id = a.employee_id
WHERE a.claimed_location <> kl.room;



-- Cross-check alibis with actual logs
SELECT 
	c.call_id,
    c.caller_id,
    c.receiver_id,
    caller.name as caller_name,
    receiver.name as receiver_name,
    c.call_time,
    c.duration_sec
FROM
    calls c
        JOIN
    employees caller ON c.caller_id = caller.employee_id
        JOIN
    employees receiver ON c.receiver_id = receiver.employee_id
where call_time between '2025-10-15 20:35:00' AND '2025-10-15 21:00:00';

-- Match evidence with movements and claims
SELECT 
    emp.employee_id,
    emp.name,
    e.room,
    e.description,
    e.found_time,
    kl.entry_time,
    kl.exit_time
FROM
    evidence e
        JOIN
    keycard_logs kl ON e.room = kl.room
        JOIN
    employees emp ON kl.employee_id = emp.employee_id
where e.room = 'CEO Office';

-- Match evidence with movements and claims
SELECT DISTINCT emp.name AS killer
FROM employees emp
JOIN keycard_logs kl 
    ON emp.employee_id = kl.employee_id
JOIN alibis a 
    ON emp.employee_id = a.employee_id
JOIN calls c 
    ON emp.employee_id = c.caller_id 
    OR emp.employee_id = c.receiver_id
JOIN evidence e 
    ON kl.room = e.room
WHERE kl.room = 'CEO Office'
  AND kl.entry_time BETWEEN '2025-10-15 20:40:00' 
                        AND '2025-10-15 21:10:00'
  AND a.claimed_location <> kl.room
  AND c.call_time BETWEEN '2025-10-15 20:35:00' 
                        AND '2025-10-15 21:00:00';
