#!/bin/bash

# Отримання імені хоста для minerName
MINER_NAME=$(hostname)

# Отримання загальної кількості потоків процесора
TOTAL_THREADS=$(lscpu | grep "CPU(s):" | head -1 | awk '{print $2}')

# Отримання вільної оперативної пам’яті (у МБ)
FREE_RAM=$(free -m | grep Mem | awk '{print $4}')

# Розрахунок кількості потоків на основі вільної RAM (2.25 ГБ = 2250 МБ на потік)
CALC_THREADS=$(echo "$FREE_RAM / 2250" | bc)

# Обмеження кількості потоків до загальної кількості потоків процесора мінус 2
MAX_THREADS=$((TOTAL_THREADS - 2))
THREADS=$((CALC_THREADS < MAX_THREADS ? CALC_THREADS : MAX_THREADS))

# Якщо THREADS менше 1, встановлюємо 1
if [ $THREADS -lt 1 ]; then
  THREADS=1
fi

# Створення файлу config.yaml
cat > config.yaml <<EOL
minerName: "$MINER_NAME"
apiKey: "nock0000-16f4-c59e-b12c-a0359b44eddd"
language: en
line: cn
extraParams:
  threads: $THREADS
  affinityStart: 0
  affinityStep: 1
EOL

# Запуск майнера в сесії screen
screen -dmS nock ./h9-miner-nock-linux-amd64

echo "Miner started in screen session 'nock' with $THREADS threads."
echo "Config file 'config.yaml' generated with minerName: $MINER_NAME."