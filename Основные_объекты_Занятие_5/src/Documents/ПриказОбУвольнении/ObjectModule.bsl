
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ВыборкаИзСправочника = Справочники.Склады.Выбрать();
	
	Пока ВыборкаИзСправочника.Следующий() Цикл
		
		Если ВыборкаИзСправочника.Ответственный = Сотрудник Тогда
		
			  СправочникОбъект = ВыборкаИзСправочника.ПолучитьОбъект();
			  
			  СправочникОбъект.Ответственный = Справочники.Сотрудники.ПустаяСсылка();
			  
			  СправочникОбъект.Записать();
			  
		КонецЕсли;
		
	
	КонецЦикла;
	
	УдалитьИзМенеджеров();
	
	//Отказ = Истина;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		Сотрудник = ДанныеЗаполнения;
		Должность = ДанныеЗаполнения.Должность;
		Подразделение = ДанныеЗаполнения.Подразделение;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриказОПриеме") Тогда

		Должность = ДанныеЗаполнения.Должность;
		Подразделение = ДанныеЗаполнения.Подразделение;
		Сотрудник = ДанныеЗаполнения.Сотрудник;
		
	КонецЕсли;

КонецПроцедуры


Процедура УдалитьИзМенеджеров()
	
	Выборка = Справочники.Контрагенты.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоГруппа Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		//Неявное объявление переменных
		НадоУдалятьИзТабличнойЧастиМенеджеры = Ложь;
		СтрокаТЧДляУдаления = Неопределено;
		
		НадоУдалятьИзОсновногоМенеджера = Ложь;
		МенеджерНаЗамену = Справочники.Сотрудники.ПустаяСсылка();
		
		//Проверяем табличную часть на наличие увольняемого сотрудника
		Для каждого ТекСТрока Из Выборка.Менеджеры Цикл
			
			Если ТекСТрока.Менеджер = Сотрудник Тогда
				
				НадоУдалятьИзТабличнойЧастиМенеджеры = Истина;

			Иначе
				
				МенеджерНаЗамену = ТекСТрока.Менеджер;
			
			КонецЕсли; 
			
		КонецЦикла;
		
		//Проверяем основного менеджера
		Если Выборка.ОсновнойМенеджер = Сотрудник Тогда
		
			НадоУдалятьИзОсновногоМенеджера = Истина;
		
		КонецЕсли;
		
		Если НадоУдалятьИзОсновногоМенеджера Или НадоУдалятьИзТабличнойЧастиМенеджеры Тогда
			
			СправочникОбъект = Выборка.ПолучитьОбъект();
			
			Если НадоУдалятьИзОсновногоМенеджера Тогда
			
				СправочникОбъект.ОсновнойМенеджер = МенеджерНаЗамену;
			
			КонецЕсли; 
			
			Если НадоУдалятьИзТабличнойЧастиМенеджеры Тогда
			
				 СтрокаТЧДляУдаления = СправочникОбъект.Менеджеры.Найти(Сотрудник,"Менеджер");
				 
				 СправочникОбъект.Менеджеры.Удалить(СтрокаТЧДляУдаления);
				 
			 КонецЕсли;
			 
			 СправочникОбъект.Записать();
		
		КонецЕсли;
		
		
	КонецЦикла;
	
КонецПроцедуры
