- view: inventory_items
  sql_table_name: demo_db.inventory_items
  fields:

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension: cost
    type: number
    sql: ${TABLE}.cost

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: product_id
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id

  - dimension_group: sold
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.sold_at

  - measure: count
    type: count
    drill_fields: [id, products.item_name, products.id, order_items.count]

