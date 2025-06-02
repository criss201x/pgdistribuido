-- Función para verificar conectividad entre nodos
CREATE OR REPLACE FUNCTION test_node_connectivity(target_host TEXT)
RETURNS BOOLEAN AS
$BODY$
DECLARE
    result BOOLEAN := FALSE;
BEGIN
    BEGIN
        PERFORM dblink_connect('test_conn', 
            format('host=%s port=5432 user=postgres password=postgres dbname=universidad', target_host));
        
        PERFORM dblink_disconnect('test_conn');
        result := TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            result := FALSE;
    END;
    
    RETURN result;
END;
$BODY$
LANGUAGE plpgsql;

-- Función para sincronización de datos
CREATE OR REPLACE FUNCTION sync_data_between_nodes()
RETURNS TEXT AS
$BODY$
DECLARE
    sync_result TEXT;
BEGIN
    -- Aquí puedes agregar lógica de sincronización específica
    sync_result := 'Sincronización completada: ' || NOW()::TEXT;
    RETURN sync_result;
END;
$BODY$
LANGUAGE plpgsql;


--SELECT sync_all_from_node('postgres-node2');
