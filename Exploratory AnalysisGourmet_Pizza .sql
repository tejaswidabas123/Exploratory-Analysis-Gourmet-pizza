-- Dashboard 1: Order and Sales Insights

-- This query provides a comprehensive view of order and sales details, including delivery addresses.
-- It selects crucial metrics such as total orders, total sales, average order value, sales by category, top-selling items, orders by hour, sales by hour, and orders by address.
SELECT
    o.id AS order_id,
    i.price AS item_price,
    o.quantity,
    i.category AS item_category,
    i.name AS item_name,
    o.created_at AS order_created_at,
    a.address_line1 AS delivery_address_line1,
    a.address_line2 AS delivery_address_line2,
    a.city AS delivery_city,
    a.zip_code AS delivery_zip_code,
    o.delivery_status AS delivery

FROM 
    FoodOrdersDB.Orders o
    LEFT JOIN FoodOrdersDB.Items i ON o.item_code = i.item_code
    LEFT JOIN FoodOrdersDB.Addresses a ON o.address_id = a.address_id;

-- Dashboard 2: Ingredient Insights and Cost Analysis

-- This query focuses on ingredient-level insights and cost analysis.
-- It calculates total quantity by ingredients, total cost of ingredients, calculated cost of a pizza, and the percentage of remaining stock by ingredient.
SELECT
    s1.item_name,
    s1.ingredient_id,
    s1.ingredient_name,
    s1.ingredient_weight,
    s1.ingredient_price,
    s1.ordered_quantity,
    s1.recipe_quantity,
    s1.ordered_quantity * s1.recipe_quantity AS ordered_ingredient_weight,
    s1.ingredient_price / s1.ingredient_weight AS unit_ingredient_cost,
    (s1.ordered_quantity * s1.recipe_quantity) * (s1.ingredient_price / s1.ingredient_weight) AS total_ingredient_cost

FROM 
    (
    -- Subquery aggregates ingredient information providing insights into total quantity and cost by ingredient.
    SELECT
        o.item_code,
        i.stock_code,
        i.item_name,
        r.ingredient_id,
        ing.ingredient_name,
        r.quantity AS recipe_quantity,
        SUM(o.quantity) AS ordered_quantity,
        ing.ingredient_weight,
        CAST(ing.ingredient_price AS DECIMAL(10, 2)) AS ingredient_price


    FROM Orders o
        LEFT JOIN Items i ON o.item_code = i.item_code
        LEFT JOIN Recipe r ON i.stock_code = r.recipe_code
        LEFT JOIN Ingredients ing ON ing.ingredient_id = r.ingredient_id

    GROUP BY 
        o.item_code, 
        i.stock_code, 
        i.item_name,
        r.ingredient_id,
        r.quantity,
        ing.ingredient_name,
        ing.ingredient_weight,
        ing.ingredient_price
    ) s1;

-- Dashboard 3: Staffing and Cost Management

-- This query provides insights into staffing costs, total hours worked, and staff details summary.
SELECT
    r.work_date,
    s.first_name,
    s.last_name,
    s.hourly_wage,
    sh.start_time,
    sh.end_time,
    (DATEDIFF(hour, sh.start_time, sh.end_time) + DATEDIFF(minute, sh.start_time, sh.end_time))/60 AS total_shift_hours,
    (DATEDIFF(hour, sh.start_time, sh.end_time) + DATEDIFF(minute, sh.start_time, sh.end_time))/60 * s.hourly_wage AS staff_cost

FROM WorkSchedule rota
    LEFT JOIN Employees s ON rota.staff_code = s.staff_code
    LEFT JOIN Shifts sh ON rota.shift_code = sh.shift_code




