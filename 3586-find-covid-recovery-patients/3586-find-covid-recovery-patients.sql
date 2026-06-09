# Write your MySQL query statement below
WITH first_positive AS (
    SELECT patient_id,
           MIN(test_date) AS positive_date
    FROM covid_tests
    WHERE result = 'Positive'
    GROUP BY patient_id
),

first_negative AS (
    SELECT fp.patient_id,
           MIN(ct.test_date) AS negative_date
    FROM first_positive fp
    JOIN covid_tests ct
      ON fp.patient_id = ct.patient_id
     AND ct.result = 'Negative'
     AND ct.test_date > fp.positive_date
    GROUP BY fp.patient_id
)

SELECT p.patient_id,
       p.patient_name,
       p.age,
       DATEDIFF(fn.negative_date, fp.positive_date) AS recovery_time
FROM patients p
JOIN first_positive fp
  ON p.patient_id = fp.patient_id
JOIN first_negative fn
  ON p.patient_id = fn.patient_id
ORDER BY recovery_time, patient_name;