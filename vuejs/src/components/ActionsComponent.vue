<script setup>
    defineProps({
        actions: {
            type: Array,
            default: () => []
        },
        currency: {
            type: String,
            default: null
        }
    });
</script>

<template>
    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="#" @click.prevent="$emit('back-to-home')" class="back-btn"><i class="bi bi-arrow-left"></i></a>
        <h1 class="text-start" style="margin: 0;">{{ $t('pages.home') }}</h1>
    </div>

    <hr>

    <h4>{{ $t('home.all_actions') }}</h4>
    <div style="overflow-x: auto; overflow-y: auto; max-height: 37vh; max-width: 100%; min-width: 100%;">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th><b>#</b></th>
                    <th><b>{{ $t('home.table_action') }}</b></th>
                    <th><b>{{ $t('home.table_employee') }}</b></th>
                    <th><b>{{ $t('home.table_time') }}</b></th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
                <tr v-for="(action, i) in [...actions].sort((a, b) => b.id - a.id)" :key="i">
                    <td>{{ action.id }}</td>
                    <td>
                        <span class="icon-bg" v-if="action.action === 'change_salary'">
                            <i v-if="currency === '$'" class="bi bi-currency-dollar text-success"></i>
                            <i v-else-if="currency === '€'" class="bi bi-currency-euro text-success"></i>
                            <i v-else-if="currency === '£'" class="bi bi-currency-pound text-success"></i>
                            <i v-else-if="currency === '¥'" class="bi bi-currency-yen text-success"></i>
                            <i v-else-if="currency === '₹'" class="bi bi-currency-rupee text-success"></i>
                            <i v-else class="bi bi-cash text-success"></i>
                        </span>
                        <span class="icon-bg" v-else-if="action.action === 'add_employee'">
                            <i class="bi bi-person-plus text-success"></i>
                        </span>
                        <span class="icon-bg" v-else-if="action.action === 'fire_employee'">
                            <i class="bi bi-person-x text-danger"></i>
                        </span>
                        <span class="icon-bg" v-else-if="action.action === 'promote_employee'">
                            <i class="bi bi-arrow-up-circle text-primary"></i>
                        </span>
                        <span class="icon-bg" v-else-if="action.action === 'demote_employee'">
                            <i class="bi bi-arrow-down-circle text-warning"></i>
                        </span>
                        <span class="icon-bg" v-else>
                            <i class="bi bi-gear text-secondary"></i>
                        </span>
                        <span style="margin-left: 0.5rem;">{{ action.actionLabel }}</span>
                    </td>
                    <td>{{ action.employee }}</td>
                    <td>{{ $formatTimestamp(action.time) }}</td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    .back-btn {
        color: var(--color-500);
        text-decoration: none;
        transition: color 0.3s;

        &:hover {
            color: white;
        }
    }

    h1 {
        font-size: 1.7rem;
        margin-bottom: 20px;
        text-align: center;
    }

    h4 {
        color: var(--color-200);
        margin-bottom: 1rem;
    }

    ::-webkit-scrollbar {
        width: 0.5rem;
        height: 0.5rem;
    }
        
    ::-webkit-scrollbar-thumb {
        background: var(--color-400);
        border-radius: 10px;
    }

    .info-section {
        flex: 1;
        color: var(--color-200);
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .stats-section,
    .additional-info {
        background-color: #ffffff10;
        border-radius: 1rem;
        padding: 1rem;
        color: var(--color-500);

        h5 {
            color: white;
        }
        
    }

    .icon-bg {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 1.8rem;
        height: 1.8rem;
        border-radius: 0.75rem;
        background: linear-gradient(135deg, rgba(15, 15, 15, 0.3) 0%, rgba(122, 122, 122, 0.3) 100%);
        margin-right: 0.75rem;
        box-shadow: 0 2px 8px 0 rgba(0,0,0,0.04);
        transition: background 0.2s, box-shadow 0.2s;
                border: 1px solid rgba(255,255,255,0.25);
        box-shadow: 0 4px 16px 0 rgba(0,0,0,0.08), 0 1.5px 4px 0 rgba(255,255,255,0.10) inset;
        vertical-align: middle;

        i {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
            font-size: 1rem;
        }
    }
</style>
