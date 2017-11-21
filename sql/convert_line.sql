CREATE OR REPLACE VIEW public.data_line AS
	WITH lines AS  (
		WITH single AS  (
				SELECT
			(ST_Dump(geom)).geom AS geom,
			DN AS dn,
			ROW_NUMBER () OVER (ORDER BY (ST_Dump(geom)).geom)  AS id
				FROM data
			)
		SELECT ST_Boundary(geom) AS geom,  dn || '.' || id AS dn FROM single
		)
	SELECT geom, 255 as val FROM lines GROUP BY dn,geom ORDER BY dn
