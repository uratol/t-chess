CREATE TABLE [engine].[instance] (
    [id]                VARCHAR (16)   NOT NULL,
    [use_for_rules]     BIT            NOT NULL,
    [use_for_ai]        BIT            NOT NULL,
    [default_for_rules] BIT            NOT NULL,
    [default_for_ai]    BIT            NOT NULL,
    [settings]          NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CHECK ([default_for_ai]=(0) OR [use_for_ai]=(1)),
    CHECK ([default_for_rules]=(0) OR [use_for_rules]=(1)),
    CHECK (isjson([settings])=(1))
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_instance_default_for_ai]
    ON [engine].[instance]([default_for_ai] ASC) WHERE ([default_for_ai]=(1));


GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_instance_default_for_rules]
    ON [engine].[instance]([default_for_rules] ASC) WHERE ([default_for_rules]=(1));

