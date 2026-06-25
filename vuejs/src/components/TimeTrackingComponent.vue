<script setup>
    import { computed, ref, watch } from 'vue'

    const props = defineProps({
        employees: {
            type: Array,
            default: () => []
        },
        summary: {
            type: Object,
            default: () => ({})
        }
    })

    const search = ref('')
    const selectedIdentifier = ref(null)
    const showDetails = ref(false)

    const filteredEmployees = computed(() => {
        const term = search.value.trim().toLowerCase()

        if (!term) {
            return props.employees
        }

        return props.employees.filter((employee) => {
            return [employee.name, employee.jobgrade, employee.identifier]
                .some((value) => String(value || '').toLowerCase().includes(term))
        })
    })

    const selectedEmployee = computed(() => {
        return props.employees.find((employee) => employee.identifier === selectedIdentifier.value) || null
    })

    watch(() => props.employees, (employees) => {
        if (!employees.some((employee) => employee.identifier === selectedIdentifier.value)) {
            selectedIdentifier.value = employees[0]?.identifier || null
        }
    }, { immediate: true })

    function openDetails(employee) {
        selectedIdentifier.value = employee.identifier
        showDetails.value = true
    }

    function closeDetails() {
        showDetails.value = false
    }
</script>

<template>
    <h1 class="text-start">{{ $t('pages.time_tracking') }}</h1>

    <hr>

    <div class="stats-grid">
        <div class="stat-box">
            <i class="bi bi-clock-history"></i>
            <div>
                <span>{{ $t('time_tracking.total_time') }}</span>
                <strong>{{ summary.totalLabel || '00h 00m' }}</strong>
            </div>
        </div>
        <div class="stat-box">
            <i class="bi bi-stopwatch"></i>
            <div>
                <span>{{ $t('time_tracking.average_shift') }}</span>
                <strong>{{ summary.averageSessionLabel || '00h 00m' }}</strong>
            </div>
        </div>
        <div class="stat-box">
            <i class="bi bi-calendar-week"></i>
            <div>
                <span>{{ $t('time_tracking.average_day') }}</span>
                <strong>{{ summary.averageDayLabel || '00h 00m' }}</strong>
            </div>
        </div>
        <div class="stat-box">
            <i class="bi bi-person-check"></i>
            <div>
                <span>{{ $t('time_tracking.active_employees') }}</span>
                <strong>{{ summary.activeCount || 0 }}/{{ summary.employeeCount || 0 }}</strong>
            </div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-box">
            <i class="bi bi-search"></i>
            <input v-model="search" type="text" :placeholder="$t('time_tracking.search_placeholder')">
        </div>
    </div>

    <div class="table-wrapper">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>{{ $t('time_tracking.table_employee') }}</th>
                    <th>{{ $t('time_tracking.table_rank') }}</th>
                    <th>{{ $t('time_tracking.table_total') }}</th>
                    <th>{{ $t('time_tracking.table_sessions') }}</th>
                    <th>{{ $t('time_tracking.table_last_activity') }}</th>
                    <th>{{ $t('time_tracking.table_status') }}</th>
                    <th>{{ $t('time_tracking.table_actions') }}</th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
                <tr v-for="employee in filteredEmployees" :key="employee.identifier">
                    <td>{{ employee.name }}</td>
                    <td>{{ employee.jobgrade }}</td>
                    <td>{{ employee.totalLabel }}</td>
                    <td>{{ employee.sessionCount }}</td>
                    <td>{{ employee.lastActivity > 0 ? $formatTimestamp(employee.lastActivity) : '-' }}</td>
                    <td>
                        <span :class="['status-badge', employee.active ? 'active' : 'ended']">
                            <i :class="employee.active ? 'bi bi-play-circle' : 'bi bi-pause-circle'"></i>
                            {{ employee.active ? $t('time_tracking.status_active') : $t('time_tracking.status_inactive') }}
                        </span>
                    </td>
                    <td>
                        <button type="button" class="btn btn-sm btn-main" @click="openDetails(employee)">
                            <i class="bi bi-bar-chart"></i>
                        </button>
                    </td>
                </tr>
                <tr v-if="filteredEmployees.length === 0">
                    <td colspan="7" class="empty">{{ $t('time_tracking.no_search_results') }}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <Teleport to="body">
        <div v-if="showDetails && selectedEmployee" class="detail-backdrop" @click.self="closeDetails">
            <div class="detail-modal">
                <div class="detail-header">
                    <div class="employee-title">
                        <div>
                            <h4>{{ selectedEmployee.name }}</h4>
                            <span>{{ selectedEmployee.jobgrade }}</span>
                        </div>
                    </div>
                    <div class="header-actions">
                        <span :class="['status-badge', selectedEmployee.active ? 'active' : 'ended']">
                            <i :class="selectedEmployee.active ? 'bi bi-play-circle' : 'bi bi-pause-circle'"></i>
                            {{ selectedEmployee.active ? $t('time_tracking.status_active') : $t('time_tracking.status_inactive') }}
                        </span>
                        <button type="button" class="btn btn-sm btn-red" @click="closeDetails" aria-label="Close">
                            <i class="bi bi-x-lg"></i>
                        </button>
                    </div>
                </div>

                <div class="detail-stats">
                    <div class="detail-stat primary">
                        <i class="bi bi-clock-history"></i>
                        <span>{{ $t('time_tracking.table_total') }}</span>
                        <strong>{{ selectedEmployee.totalLabel }}</strong>
                    </div>
                    <div class="detail-stat">
                        <i class="bi bi-list-check"></i>
                        <span>{{ $t('time_tracking.table_sessions') }}</span>
                        <strong>{{ selectedEmployee.sessionCount }}</strong>
                    </div>
                    <div class="detail-stat">
                        <i class="bi bi-calendar-check"></i>
                        <span>{{ $t('time_tracking.active_days') }}</span>
                        <strong>{{ selectedEmployee.dayCount }}</strong>
                    </div>
                    <div class="detail-stat">
                        <i class="bi bi-stopwatch"></i>
                        <span>{{ $t('time_tracking.average_shift') }}</span>
                        <strong>{{ selectedEmployee.avgSessionLabel }}</strong>
                    </div>
                    <div class="detail-stat">
                        <i class="bi bi-calendar-week"></i>
                        <span>{{ $t('time_tracking.average_day') }}</span>
                        <strong>{{ selectedEmployee.avgDayLabel }}</strong>
                    </div>
                    <div class="detail-stat wide">
                        <i class="bi bi-activity"></i>
                        <span>{{ $t('time_tracking.table_last_activity') }}</span>
                        <strong>{{ selectedEmployee.lastActivity > 0 ? $formatTimestamp(selectedEmployee.lastActivity) : '-' }}</strong>
                    </div>
                </div>

                <div class="detail-columns">
                    <section class="detail-panel">
                        <div class="panel-header">
                            <h5>{{ $t('time_tracking.days_title') }}</h5>
                            <span>{{ selectedEmployee.days.length }}</span>
                        </div>
                        <div class="mini-table">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>{{ $t('time_tracking.table_day') }}</th>
                                        <th>{{ $t('time_tracking.table_total') }}</th>
                                        <th>{{ $t('time_tracking.table_sessions') }}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="day in selectedEmployee.days" :key="day.date">
                                        <td>{{ day.date }}</td>
                                        <td>{{ day.totalLabel }}</td>
                                        <td>{{ day.sessionCount }}</td>
                                    </tr>
                                    <tr v-if="selectedEmployee.days.length === 0">
                                        <td colspan="3" class="empty">{{ $t('time_tracking.no_entries') }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </section>

                    <section class="detail-panel">
                        <div class="panel-header">
                            <h5>{{ $t('time_tracking.sessions_title') }}</h5>
                            <span>{{ selectedEmployee.sessions.length }}</span>
                        </div>
                        <div class="mini-table">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>{{ $t('time_tracking.table_start') }}</th>
                                        <th>{{ $t('time_tracking.table_end') }}</th>
                                        <th>{{ $t('time_tracking.table_duration') }}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="session in selectedEmployee.sessions" :key="`${session.time_start}-${session.time_end}`">
                                        <td>{{ $formatTimestamp(session.time_start) }}</td>
                                        <td>{{ session.active ? '-' : $formatTimestamp(session.time_end) }}</td>
                                        <td>{{ session.durationLabel }}</td>
                                    </tr>
                                    <tr v-if="selectedEmployee.sessions.length === 0">
                                        <td colspan="3" class="empty">{{ $t('time_tracking.no_entries') }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </Teleport>
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    h1 {
        font-size: 1.7rem;
        margin-bottom: 20px;
    }

    h4,
    h5 {
        color: var(--color-200);
        margin: 0;
    }

    h5 {
        font-size: 0.95rem;
        margin-bottom: 0.5rem;
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 0.75rem;
    }

    .stat-box {
        display: flex;
        align-items: center;
        gap: 0.6rem;
        min-width: 0;
        padding: 0.7rem;
        border: 1px solid var(--color-700);
        border-radius: 8px;
        background: #ffffff10;

        i {
            color: var(--color-400);
            font-size: 1.1rem;
        }

        span {
            display: block;
            color: var(--color-200);
            font-size: 0.72rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        strong {
            color: white;
            font-size: 0.95rem;
        }
    }

    .toolbar {
        margin: 0.75rem 0;
    }

    .search-box {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.55rem 0.7rem;
        border: 1px solid var(--color-700);
        border-radius: 8px;
        background: #ffffff08;

        i {
            color: var(--color-400);
        }

        input {
            width: 100%;
            min-width: 0;
            color: white;
            background: transparent;
            border: 0;
            outline: 0;

            &::placeholder {
                color: var(--color-300);
            }
        }
    }

    .table-wrapper {
        overflow-x: auto;
        overflow-y: auto;
        max-height: 27vh;
    }

    th,
    td {
        white-space: nowrap;
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.35rem;
        padding: 0.25rem 0.5rem;
        border-radius: 6px;
        font-size: 0.8rem;
        font-weight: 700;

        &.active {
            color: #34d399;
            background: rgba(52, 211, 153, 0.12);
        }

        &.ended {
            color: var(--color-200);
            background: rgba(255, 255, 255, 0.08);
        }
    }

    .detail-backdrop {
        position: fixed;
        inset: 0;
        z-index: 1000;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 1.5rem;
        background: rgba(0, 0, 0, 0.55);
    }

    .detail-modal {
        display: flex;
        flex-direction: column;
        gap: 0.9rem;
        width: min(72vw, 1180px);
        height: min(74vh, 780px);
        padding: 1rem;
        border: 1px solid var(--color-700);
        border-radius: 12px;
        background: var(--color-900);
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        overflow: hidden;
    }

    .detail-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 1rem;
        padding-bottom: 0.8rem;
        border-bottom: 1px solid var(--color-700);

        span {
            color: var(--color-200);
            font-size: 0.85rem;
        }
    }

    .employee-title,
    .header-actions {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        min-width: 0;
    }

    .detail-stats {
        display: grid;
        grid-template-columns: repeat(6, minmax(0, 1fr));
        gap: 0.6rem;

        .detail-stat {
            position: relative;
            min-width: 0;
            padding: 0.72rem 0.72rem 0.68rem;
            border: 1px solid var(--color-700);
            border-radius: 8px;
            background: #ffffff10;
            overflow: hidden;

            &.primary {
                grid-column: span 2;
            }

            &.wide {
                grid-column: span 2;
            }
        }

        i {
            position: absolute;
            right: 0.65rem;
            top: 0.6rem;
            color: var(--color-400);
        }

        span {
            display: block;
            color: var(--color-200);
            font-size: 0.75rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        strong {
            display: block;
            color: white;
            font-size: 0.95rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    }

    .detail-columns {
        display: grid;
        grid-template-columns: 0.85fr 1.15fr;
        gap: 0.8rem;
        min-height: 0;
        flex: 1;

        > section {
            display: flex;
            flex-direction: column;
            min-height: 0;
        }
    }

    .detail-panel {
        border: 1px solid var(--color-700);
        border-radius: 8px;
        background: #ffffff08;
        overflow: hidden;
    }

    .panel-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 0.75rem;
        padding: 0.7rem 0.8rem;
        border-bottom: 1px solid var(--color-700);
        background: #ffffff10;

        span {
            min-width: 1.65rem;
            padding: 0.12rem 0.45rem;
            border-radius: 4px;
            color: white;
            background: var(--color-700);
            font-size: 0.72rem;
            font-weight: 800;
            text-align: center;
        }
    }

    .mini-table {
        flex: 1;
        overflow: auto;

        table {
            margin: 0;
            font-size: 0.8rem;
        }

        thead th {
            position: sticky;
            top: 0;
            z-index: 1;
            background: var(--color-800);
        }
    }

    .empty {
        color: var(--color-200);
        text-align: center;
        padding: 1rem;
    }

    ::-webkit-scrollbar {
        width: 0.5rem;
        height: 0.5rem;
    }

    ::-webkit-scrollbar-thumb {
        background: var(--color-400);
        border-radius: 10px;
    }
</style>
