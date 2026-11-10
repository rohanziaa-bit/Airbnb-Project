{% macro tag(col) %}
     CASE 
         WHEN {{ col }} < 100 then 'low'
         WHEN {{ col }} < 200 then 'medium'
            ELSE 'high'
        END
{% endmacro %}