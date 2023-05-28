DROP TABLE IF EXISTS holdings_notes;

-- Create a local table for notes in holdings records that includes the type id and name. Here note can be either public or for staff.
CREATE TABLE holdings_notes AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    instance_id AS instance_id,
    json_extract_path_text(notes.data, 'holdingsNoteTypeId') AS note_type_id,
    holdings_note_types.name AS note_type_name,
    json_extract_path_text(notes.data, 'note') AS note,
    json_extract_path_text(notes.data, 'staffOnly')::boolean AS staff_only
FROM
    inventory_holdings AS holdings
    CROSS JOIN json_array_elements(json_extract_path(data, 'notes')) AS notes (data)
    LEFT JOIN inventory_holdings_note_types AS holdings_note_types ON json_extract_path_text(notes.data, 'holdingsNoteTypeId') = holdings_note_types.id;

