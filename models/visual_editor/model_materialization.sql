WITH model_builds AS (
  SELECT
    *
  FROM {{ ref('dim_dbt__models') }}
), input_2 AS (
  SELECT
    *
  FROM {{ ref('dim_dbt__seeds') }}
), join_1 AS (
  SELECT
    model_builds.MODEL_EXECUTION_ID,
    model_builds.COMMAND_INVOCATION_ID,
    model_builds.NODE_ID,
    model_builds.RUN_STARTED_AT,
    model_builds.DATABASE,
    model_builds.SCHEMA,
    model_builds.PACKAGE_NAME,
    model_builds.NAME,
    model_builds.DEPENDS_ON_NODES,
    model_builds.PATH,
    model_builds.CHECKSUM,
    model_builds.MATERIALIZATION,
    model_builds.TAGS,
    model_builds.META,
    model_builds.ALIAS,
    input_2.SEED_EXECUTION_ID
  FROM model_builds
  LEFT JOIN input_2
    ON model_builds.NODE_ID = input_2.NODE_ID
), formula_1 AS (
  SELECT
    *,
    CASE WHEN SEED_EXECUTION_ID IS NULL THEN FALSE ELSE TRUE END AS is_seed
  FROM join_1
), rename_1 AS (
  SELECT
    *
    RENAME (MATERIALIZATION AS materialized_as)
  FROM formula_1
), filter_1 AS (
  SELECT
    *
  FROM rename_1
  WHERE
    RUN_STARTED_AT > '2025-01-01'
), aggregate_1 AS (
  SELECT
    materialized_as,
    is_seed,
    COUNT(MODEL_EXECUTION_ID) AS count_MODEL_EXECUTION_ID
  FROM filter_1
  GROUP BY
    materialized_as,
    is_seed
), model_materialization_sql AS (
  SELECT
    *
  FROM aggregate_1
)
SELECT
  *
FROM model_materialization_sql