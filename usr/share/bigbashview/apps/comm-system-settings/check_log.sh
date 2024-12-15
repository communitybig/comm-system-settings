#!/usr/bin/env bash

LOG_FILE=~/.config/system_settings_log.json

# Função para atualizar o estado de uma tarefa pelo ID
update_task_state() {
    local task_id=$1
    local new_state=$2

    # Verifica se a tarefa já existe no JSON
    if [[ -n $(jq --argjson id "$task_id" '.TASK[] | select(.id == $id)' "$LOG_FILE") ]]; then
        # Atualiza o estado da tarefa existente
        jq --argjson id "$task_id" --argjson state "$new_state" \
           '(.TASK[] | select(.id == $id).isActive) = $state' \
           "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
    else
        # Adiciona a nova tarefa ao JSON
        jq --argjson id "$task_id" --argjson state "$new_state" \
           '.TASK += [{"id": $id, "isActive": $state}]' \
           "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
    fi
}

check_file() {
    # Cria o arquivo JSON se ele não existir
    if [ ! -f "$LOG_FILE" ]; then
        echo '{"TASK":[]}' > "$LOG_FILE"
        for n in {1..5};do
            update_task_state "$n" 0
        done
    fi
}

# Processa os argumentos
if [ "$1" == "update" ]; then
    check_file
    update_task_state "$2" "$3"
else
    check_file
fi
