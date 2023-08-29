USE ObliDB2
GO
--Inicio Funcion 3a
CREATE FUNCTION fn_PromedioOperativo(@Año int)
RETURNS DECIMAL(8,2)
AS
	BEGIN
		DECLARE @retorno DECIMAL(8,2)
		SELECT @retorno = AVG(Costo)
		FROM Operativos
		WHERE YEAR(FechaHora) = @Año

		RETURN @retorno
	END

GO

--Fin Funcion 3a

--Inicio Procedimiento 3b
CREATE PROCEDURE spu_AumentarCostosPlanta @IdPlanta INT, @Porcentaje DECIMAL(5,2), @FechaInicio DATE, @FechaFin DATE, @Total DECIMAL(8,2) OUT
AS
	BEGIN
		DECLARE @TotalOperativo DECIMAL(8,2)
		SELECT  @TotalOperativo = SUM(Costo)
		FROM Operativos
		WHERE IdPlanta = @IdPlanta AND (FEchaHora BETWEEN @FechaInicio AND @FechaFin)

		UPDATE Operativos
		SET Costo = Costo*(1+(@Porcentaje/100))
		WHERE IdPlanta = @IdPlanta AND (FEchaHora BETWEEN @FechaInicio AND @FechaFin)

		DECLARE @NuevoTotalOperativo DECIMAL(8,2)
		SELECT  @NuevoTotalOperativo = SUM(Costo)
		FROM Operativos
		WHERE IdPlanta = @IdPlanta AND (FEchaHora BETWEEN @FechaInicio AND @FechaFin)

		DECLARE @TotalNutriente DECIMAL(8,2)
		SELECT  @TotalNutriente = SUM(Precio)
		FROM ProductoNutriente
		WHERE IdPlanta = @IdPlanta AND (FEchaHora BETWEEN @FechaInicio AND @FechaFin)

		UPDATE ProductoNutriente
		SET Precio = Precio*(1+(@Porcentaje/100))
		WHERE IdPlanta = @IdPlanta AND (FEchaHora BETWEEN @FechaInicio AND @FechaFin)

		DECLARE @NuevoTotalNutriente DECIMAL(8,2)
		SELECT  @NuevoTotalNutriente = SUM(Precio)
		FROM ProductoNutriente
		WHERE IdPlanta = @IdPlanta AND (FEchaHora BETWEEN @FechaInicio AND @FechaFin)


		IF @NuevoTotalOperativo IS NOT NULL AND @TotalOperativo IS NOT NULL AND @NuevoTotalNutriente IS NOT NULL AND @TotalNutriente IS NOT NULL
			BEGIN
				SET @Total = (@NuevoTotalOperativo - @TotalOperativo) + (@NuevoTotalNutriente - @TotalNutriente)
			END
		ELSE IF @NuevoTotalOperativo IS NOT NULL AND @TotalOperativo IS NOT NULL
			BEGIN
				SET @Total = (@NuevoTotalOperativo - @TotalOperativo)
			END
		ELSE IF @NuevoTotalNutriente IS NOT NULL AND @TotalNutriente IS NOT NULL
			BEGIN
				SET @Total = (@NuevoTotalNutriente - @TotalNutriente)
			END
		ELSE
			BEGIN
				SET @Total = 0
			END
		PRINT 'Diferencia de costo total: ' + CAST(@Total AS NVARCHAR)
	END

GO
--Fin Procedimiento 3b