<script setup>
    defineProps({
        transactions: {
            type: Array,
            default: () => []
        }
    });
</script>

<template>
    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="#" @click.prevent="$emit('back-to-account')" class="back-btn"><i class="bi bi-arrow-left"></i></a>
        <h1 class="text-start" style="margin: 0;">Account</h1>
    </div>

    <hr>

    <h4>All Transactions</h4>
    <div style="overflow-x: auto; overflow-y: auto; max-height: 37vh; max-width: 100%; min-width: 100%;">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th><b>#</b></th>
                    <th><b>Action</b></th>
                    <th><b>Employee</b></th>
                    <th><b>Amount</b></th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
                <tr v-for="(transaction, i) in [...transactions].sort((a, b) => b.id - a.id)" :key="i">
                    <td>{{ transaction.id }}</td>
                    <td>{{ transaction.action }}</td>
                    <td>{{ transaction.employee }}</td>
                    <td>{{ transaction.amount }}</td>
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
</style>
