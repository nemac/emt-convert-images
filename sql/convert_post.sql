CREATE OR REPLACE VIEW public.data_poly AS
		WITH single AS  (
		    SELECT
			(ST_Dump(geom)).geom AS geom,
			DN AS dn,
			ROW_NUMBER () OVER (ORDER BY (ST_Dump(geom)).geom)  AS id
		    FROM data
		  )
		SELECT geom,  dn || '.' || id AS dn FROM single
