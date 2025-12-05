#!/bin/bash

echo "========================================"
echo " ОТКЛЮЧЕНИЕ АНИМАЦИЙ И БЛОКИРОВКА РЕКЛАМЫ"
echo "========================================"

# Проверка ADB
adb devices | grep -w "device" > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Ошибка: Устройство не подключено!"
    exit 1
fi

echo "✓ Устройство подключено"

# 1. Отключаем анимации
echo ""
echo "1. Отключаем анимации..."
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0
echo "✓ Анимации отключены"

# 2. Настраиваем DNS для блокировки рекламы
echo ""
echo "2. Настраиваем DNS AdGuard..."
adb shell settings put global private_dns_mode hostname
adb shell settings put global private_dns_specifier dns.adguard.com
echo "✓ DNS настроен"

# 3. Отключаем персонализированную рекламу
echo ""
echo "3. Отключаем отслеживание рекламы..."
adb shell settings put secure limit_ad_tracking 1
adb shell settings put secure usage_metrics_marketing_opt_out 1
echo "✓ Персонализация отключена"

# 4. Отключаем телеметрию
echo ""
echo "4. Отключаем телеметрию..."
adb shell settings put global upload_log_pref 0
adb shell settings put secure stats_collection_enabled 0
adb shell settings put global send_action_app_error 0
echo "✓ Телеметрия отключена"

# 5. Отключаем рекламные сервисы Google
echo ""
echo "5. Отключаем рекламные сервисы..."
adb shell pm disable-user --user 0 com.google.android.gms.ads 2>/dev/null || true
adb shell pm disable-user --user 0 com.google.android.gms.ads.dynamite 2>/dev/null || true
echo "✓ Рекламные сервисы отключены"

# 6. Дополнительные настройки производительности
echo ""
echo "6. Дополнительные настройки..."
# Отключение аппаратного ускорения (может помочь на слабых устройствах)
# adb shell settings put global debug.hwui.disable_vsync true
# adb shell settings put global debug.hwui.overdraw false

# Оптимизация для слабых устройств
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0

# Отключение live wallpaper
adb shell settings put global window_live_wallpaper 0

echo "✓ Дополнительные настройки применены"

echo ""
echo "========================================"
echo "           ГОТОВО!"
echo "========================================"
echo ""
echo "Рекомендации:"
echo "1. Перезагрузите устройство"
echo "2. Проверьте настройки DNS в: Настройки → Сеть → Частный DNS"
echo "3. Для возврата настроек:"
echo "   adb shell settings put global animator_duration_scale 1"
echo "   adb shell settings put global private_dns_mode opportunistic"