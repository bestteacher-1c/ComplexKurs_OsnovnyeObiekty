
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаПоДокументу = Товары.Итог("Сумма");
	
	ПороговаяСумма = Константы.СуммаПокупкиДляБесплатнойДоставки.Получить();
	
	Если ПороговаяСумма <= 0 Тогда
		ПороговаяСумма = 1000; // значение по умолчанию, если пользователь не заполнил константу
	КонецЕсли;
	
	Если СуммаПоДокументу >= ПороговаяСумма Тогда
		
		ДополнительныеСвойства.Вставить("Текст","----------- ВНИМАНИЕ! -----------
		|Покупатель приобрел товаров на общую сумму " + Формат(СуммаПоДокументу, "ЧДЦ=2") +
		" руб. Возможна бесплатная доставка товаров клиенту.");
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ДополнительныеСвойства.Текст;
		Сообщение.Сообщить();

	КонецЕсли;
	
КонецПроцедуры

