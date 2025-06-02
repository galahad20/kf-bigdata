CREATE OR REPLACE TABLE `rakamin-kf-analytics-461708.kimia_farma.kf_analisa` AS
SELECT
  trx.transaction_id,
  trx.date,
  cab.branch_id,
  cab.branch_name,
  cab.kota,
  cab.provinsi,
  cab.rating AS rating_cabang,
  trx.customer_name,
  trx.product_id,
  prod.product_name,
  prod.price AS actual_price,
  trx.discount_percentage,
  
  -- Hitung persentase laba
  CASE
    WHEN prod.price <= 50000 THEN 0.10
    WHEN prod.price <= 100000 THEN 0.15
    WHEN prod.price <= 300000 THEN 0.20
    WHEN prod.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Hitung nett_sales dan nett_profit
  prod.price * (1 - trx.discount_percentage) AS nett_sales,
  prod.price * (1 - trx.discount_percentage) *
    CASE
      WHEN prod.price <= 50000 THEN 0.10
      WHEN prod.price <= 100000 THEN 0.15
      WHEN prod.price <= 300000 THEN 0.20
      WHEN prod.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS nett_profit,

  trx.rating AS rating_transaksi

FROM `rakamin-kf-analytics-461708.kimia_farma.kf_final_transaction` trx
JOIN `rakamin-kf-analytics-461708.kimia_farma.kf_product` prod
  ON trx.product_id = prod.product_id
JOIN `rakamin-kf-analytics-461708.kimia_farma.kf_kantor_cabang` cab
  ON trx.branch_id = cab.branch_id
