- view: active_users
- explore: use_rolling_30_day_window
  joins:
  - join: users
    relationship: one_to_one
    sql_on: ${use_rolling_30_day_window.user_id} = ${users.id}

- view: dates
  derived_table:
    sql: |
      -- ## 1) Create a Date table with a row for each date.
      SELECT '2001-01-01'::DATE + d AS date
      FROM 
        (SELECT ROW_NUMBER() OVER(ORDER BY id) -1 AS d FROM orders ORDER BY id LIMIT 20000) AS  d
    
    
  
- view: use_rolling_30_day_window
  derived_table:
    sql: | 
      WITH daily_use AS (
        -- ## 2 ) Create a table of days and activity by user_id
        SELECT 
          user_id
          , DATE_TRUNC('day', created_at) as activity_date
        FROM orders
      )
      --  ## 3) Cross join activity and dates to build a row for each user/date combo with
      -- days since last activity
      SELECT
            daily_use.user_id
          , wd.date as date
          , MIN(wd.date::date - daily_use.activity_date::date) as days_since_last_action
      FROM ${dates.SQL_TABLE_NAME} AS wd 
      LEFT JOIN daily_use
          ON wd.date >= daily_use.activity_date
          AND wd.date < daily_use.activity_date + interval '30 day'
      GROUP BY 1,2    
   
    
  fields:
    - dimension_group: date
      type: date
      sql: ${TABLE}.date
      
    - dimension: user_id
      type: number
      sql: ${TABLE}.user_id
      
    - dimension: days_since_last_action
      type: number
      sql: ${TABLE}.days_since_last_action
      value_format_name: decimal_0
      
    - dimension: active_this_day
      type: yesno
      sql: ${days_since_last_action} <  1   
      
    - dimension: active_last_7_days
      type: yesno
      sql: ${days_since_last_action} < 7      
      
    - measure: user_count_active_30_days
      label: 'Monthly Active Users'
      type: count_distinct
      sql: ${user_id}
      drill_fields: [users.id, users.name]
      
    - measure: user_count_active_this_day
      label: 'Daily Active Users'
      type: count_distinct
      sql: ${user_id}
      drill_fields: [users.id, users.name]
      filters:
        active_this_day: yes
       
    - measure: user_count_active_7_days
      label: 'Weekly Active Users'
      type: count_distinct
      sql: ${user_id}
      drill_fields: [users.id, users.name]
      filters:
        active_last_7_days: yes