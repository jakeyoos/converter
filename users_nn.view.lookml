- view: users_nn
  sql_table_name: demo_db.usersNN
  fields:

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension: first_name
    type: string
    sql: ${TABLE}.first_name

  - dimension: last_name
    type: string
    sql: ${TABLE}.last_name

  - measure: count
    type: count
    drill_fields: [id, first_name, last_name]

