
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) = Ложь Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Документ 'Заявка на транспорт' вводится только на основании 'Расходной накладной'.";
		Сообщение.Сообщить();
		
		Отказ = Истина;
		
		Возврат;
	КонецЕсли;
	
	СуммаПокупки = Объект.ДокументОснование.СуммаПоДокументу;
	
	ПороговаяСумма = Константы.СуммаПокупкиДляБесплатнойДоставки.Получить();
	
	ПороговаяСумма = ?(ПороговаяСумма <= 0, 1000, ПороговаяСумма);
	
	Если СуммаПокупки < ПороговаяСумма Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Суммы покупки недостаточно для оформления бесплатной доставки.";
		Сообщение.Сообщить();
		
		Отказ = Истина;
		
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура МашинаПриИзменении(Элемент)
	
	ПолучитьДанныеПоБригаде();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеПоБригаде()
	
	Если ЗначениеЗаполнено(Объект.Машина) = Ложь Тогда
		
		Объект.Водитель = Справочники.Сотрудники.ПустаяСсылка();
		Объект.ПервыйГрузчик = Справочники.Сотрудники.ПустаяСсылка();
		Объект.ВторойГрузчик = Справочники.Сотрудники.ПустаяСсылка();
		
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Водитель,
	|	ПервыйГрузчик,
	|	ВторойГрузчик
	|ИЗ
	|	РегистрСведений.СформированныеБригады
	|ГДЕ
	|	Период = &НачалоДняДатыДокумента И
	|	Машина = &ВыбраннаяМашина
	|";
	
	Запрос.УстановитьПараметр("НачалоДняДатыДокумента", НачалоДня(Объект.Дата));
	Запрос.УстановитьПараметр("ВыбраннаяМашина", Объект.Машина);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Сообщить("На " + Формат(Объект.Дата, "ДЛФ=DD") + " к выбранной машине не прикреплена бригада.");
		
		Объект.Машина = Справочники.ТранспортныеСредства.ПустаяСсылка();
		
		Объект.Водитель = Справочники.Сотрудники.ПустаяСсылка();
		Объект.ПервыйГрузчик = Справочники.Сотрудники.ПустаяСсылка();
		Объект.ВторойГрузчик = Справочники.Сотрудники.ПустаяСсылка();
		
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Объект.Водитель = Выборка.Водитель;
	Объект.ПервыйГрузчик = Выборка.ПервыйГрузчик;
	Объект.ВторойГрузчик = Выборка.ВторойГрузчик;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Элементы.СотрудникТранспортногоОтдела.Доступность = Ложь;
		
	КонецЕсли; 
	
КонецПроцедуры

