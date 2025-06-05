<script setup>
    const emit = defineEmits(['open-salary-modal'])

    defineProps({
        saleries: {
            type: Array,
            default: () => []
        }
    });

    function openSalaryModal(salary) {
        emit('open-salary-modal', salary)
    }
</script>

<template>
    <h1 class="text-start">{{ $t('pages.salaries') }}</h1>

    <hr>

    <div style="overflow-x: auto; overflow-y: auto; max-height: 41vh; max-width: 100%; min-width: 100%;">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th style="font-weight: bold;">#</th>
                    <th style="font-weight: bold;">{{ $t('salaries.table_name') }}</th>
                    <th style="font-weight: bold;">{{ $t('salaries.table_salary') }}</th>
                    <th style="font-weight: bold;">{{ $t('salaries.table_actions') }}</th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
                <tr v-for="(salary, i) in [...saleries].sort((a, b) => b.grade - a.grade)" :key="i">
                    <td>{{ salary.grade }}</td>
                    <td>{{ salary.grade_label }}</td>
                    <td>{{ salary.salary }}</td>
                    <td class="buttons">
                        <button class="btn btn-sm btn-primary" @click="openSalaryModal(salary)">{{ $t('buttons.change') }}</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    h1 {
        font-size: 1.7rem;
        margin-bottom: 20px;
        text-align: center;
    }

    ::-webkit-scrollbar {
        width: 0.5rem;
        height: 0.5rem;
    }

    ::-webkit-scrollbar-thumb {
        background: var(--color-400);
        border-radius: 10px;
    }

    table {
        .buttons {
            display: flex;
            gap: 10px;
        }

        .btn-primary {
            background-color: var(--color-500);
            border: none !important;
            box-shadow: none !important;

            &:hover {
                background-color: var(--color-600);
            }

            &:active {
                background-color: var(--color-700) !important;
                color: #fff !important;
                border: none !important;
                box-shadow: none !important;
            }
        }
        
    }
</style>