# 🌿 Скрипты районных проектов

Скрипты статистики для [районов Свердловской области](https://www.inaturalist.org/projects/bioraznoobrazie-rayonov-sverdlovskoy-oblasti).

+ Скрипты могут и будут меняться по мере развития как проекта **[🌿 iNatGet](https://github.com/inat-get/inat-get)**, так
  указанных проектов на **[iNaturalist](https://www.inaturalist.org/)**.
+ Скрипты выложены в открытый доступ для использования в качестве примеров. Вы можете взять их и использовать для своих
  проектов с минимальными изменениями, не забывая про лицензию — **[GNU GPL v3](LICENSE)**.
+ Скрипты выдаеют результат как бы в формате Markdown, но в действительности это упрощенный HTML специально для постов
  в журналах проектов iNaturalist.

## Использование

### Установка

```shell
git clone https://github.com/inat-get/ing-sv-districts.git
cd ing-sv-districts
bundle install
```

### Подготовка

```shell
bundle exec ruby generate.rb
```
Это сформирует скрипты для вызова в подкаталоге `generated` и их список в `generated.lst`.

### Запуск

```shell
bundle exec inat-get -c inat-get.yml @generated.lst
```
