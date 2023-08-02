CREATE TABLE [engine_native].[board] (
    [id]                   UNIQUEIDENTIFIER NOT NULL,
    [white_to_move]        BIT              NOT NULL,
    [white_king_castling]  BIT              NOT NULL,
    [white_queen_castling] BIT              NOT NULL,
    [black_king_castling]  BIT              NOT NULL,
    [black_queen_castling] BIT              NOT NULL,
    [en_passant_col]       TINYINT          NULL,
    [half_moves]           INT              NOT NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC)
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);

