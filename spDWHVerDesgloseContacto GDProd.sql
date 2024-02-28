SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS(SELECT * FROM sysobjects WHERE TYPE='P' AND NAME='spDWHVerDesgloseContacto')
DROP PROCEDURE spDWHVerDesgloseContacto
GO

CREATE PROC [dbo].[spDWHVerDesgloseContacto] 
									@Filtro   VARCHAR(20),
                                    @ValorContacto     CHAR(10),
                                    @ValorMovimiento   CHAR(20),
                                    @ValorProyecto     VARCHAR(50),
                                    @ValorUEN          Varchar(5),
                                    @ValorFechaEmision DATETIME,
                                    @ValorCC           VARCHAR(20),

                                    -- @ValorCuentaDinero CHAR(10),
                                    @Cuenta            CHAR(15),
                                    @Empresa           CHAR(5),
                                    @Sucursal            INT,
                                    @Ejercicio         CHAR(5),
                                    @PeriodoD          CHAR(5),
                                    @PeriodoA          CHAR(5),
                                    @Moneda            CHAR(20),
                                    @TipoCto		varchar(20)
AS
  BEGIN
      SET ansi_nulls OFF

      DECLARE @Contacto          CHAR(10),
              @Movimiento        CHAR(20),
              @Proyecto          VARCHAR(50),
              @UEN               INT,
              @FechaEmision      DATETIME,
              @CC                VARCHAR(20),
              @CuentaDinero      CHAR(10),
              @ValorCuentaDinero CHAR(10),
                @Servidor		varchar(30),
				@Base			varchar(30),
				@BaseT			varchar(100),
				@Comando	 Nvarchar(1000),
				@Rama			varchar(10),
				@PeriodoAnt		INT,
				@Clave			varchar(100),
				@SPid           INT

 SET ANSI_NULLS ON  
 SET ANSI_WARNINGS ON  
 SET TRANSACTION isolation level READ uncommitted  

select @SPid = @@SPID


    SELECT @Clave=Clave, @Servidor = NULLIF(RTRIM(Servidor), ''), @Base = NULLIF(RTRIM(Base), '')
    FROM DicoServReportes WHERE Clave='ServidorReportes' AND Empresa=@Empresa

    IF @Clave IS NULL
		RAISERROR('No está dado de alta el Servidor de Reportes',16,-1)

    IF @Servidor IS NULL
    SELECT @Servidor=@@SERVERNAME
    
    IF @Base IS NULL
    SELECT @Base=DB_NAME()
    
	SELECT @Servidor = '[' + RTRIM(@Servidor) + ']' + '.['
	SELECT @BaseT = @Base + '].[dbo].[spDWHVerDesgloseContacto]'


SELECT @Comando = 'EXEC '+ @Servidor + @BaseT +' ''' + @Filtro +''',' +''''+RTRIM(@ValorContacto)+''',' 
+''''+rtrim(@ValorMovimiento) +''','
+''''+ rtrim(@ValorProyecto)  +''',' 
+''''+ rtrim(@ValorUEN) +''',' 	
+''''+  Convert(varchar,@ValorFechaEmision,103)+''',' 
+''''+  @ValorCC  +''',' 
+''''+ @Cuenta  +''',' 
+''''+  @Empresa +''',' 
+
 ISNULL(convert(varchar,@Sucursal,10),'NULL')  
+', '+ @Ejercicio +',' 
+ @PeriodoD  +','
+  @PeriodoA+','
+''''+   @Moneda +''',' 
+''''+  @TipoCto+''','
+ Convert(varchar,@SPid,5)

EXECUTE sp_executesql @Comando


  END 
GO


