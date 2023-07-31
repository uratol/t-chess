CREATE TABLE [chess].[board_piece] (
    [board_id]         UNIQUEIDENTIFIER NOT NULL,
    [colored_piece_id] VARCHAR (12)     NOT NULL,
    [col]              TINYINT          NOT NULL,
    [row]              TINYINT          NOT NULL,
    [field]            AS               (char([col]+(65))),
    [rank]             AS               ([row]+(1)),
    [position]         AS               (concat(char([col]+(65)),[row]+(1))),
    [id]               UNIQUEIDENTIFIER CONSTRAINT [DF__board_piece__id__4D5F7D71] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK__board_pi__3213E83F690BB660] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [CK__board_piece__col__66603565] CHECK ([col]<(8)),
    CONSTRAINT [CK__board_piece__col__6C190EBB] CHECK ([col]<(8)),
    CONSTRAINT [CK__board_piece__row__6754599E] CHECK ([row]<(8)),
    CONSTRAINT [CK__board_piece__row__6D0D32F4] CHECK ([row]<(8)),
    CONSTRAINT [FK__board_pie__board__6477ECF3] FOREIGN KEY ([board_id]) REFERENCES [chess].[board] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK__board_pie__color__6A30C649] FOREIGN KEY ([colored_piece_id]) REFERENCES [chess].[colored_piece] ([id]),
    CONSTRAINT [UQ__board_pi__E75D4182BC543731] UNIQUE NONCLUSTERED ([board_id] ASC, [col] ASC, [row] ASC)
);

