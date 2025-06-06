<script setup>
    import { getCurrentInstance } from 'vue'

    const { proxy } = getCurrentInstance()
    const $t = proxy.$t

    const props = defineProps({
        notifiesRef: Object,
        account: {
            type: String,
            default: '0'
        },

        transactions: {
            type: Array,
            default: () => []
        },

        currency: {
            type: String,
            default: null
        }
    })

    async function deposit() {
        const amount = document.getElementById('amount');

        if (amount.value > 0) {
            try {
                const respone = await fetch(`https://${GetParentResourceName()}/deposit`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                    },
                    body: JSON.stringify({
                        amount: amount.value
                    })
                });
                const text = await respone.text();

                if (text === '"ok"') {
                    props.notifiesRef?.triggerAlert('success', $t('notifies.account.deposit.success', {amount: amount.value}));
                } else if (text === '"not_enough_money"') {
                    props.notifiesRef?.triggerAlert('warning', $t('notifies.account.deposit.not_enough_money'));
                } else if (text === '"error"') {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.account.deposit.error'));
                } else if (text === '"unknown_error"') {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.account.deposit.unknown_error'));
                } else {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.account.deposit.unknown'));
                }

                } catch (error) {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.account.deposit.nui_error', {error: error.message}));
                }
        } else {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.account.deposit.invalid_amount'));
        }

        document.getElementById('amount').value = '';
    }

    async function withdraw() {
        const amount = document.getElementById('amount');

        if (amount.value > 0) {
            try {
                const respone = await fetch(`https://${GetParentResourceName()}/withdraw`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                    },
                    body: JSON.stringify({
                        amount: amount.value
                    })
                });
                const text = await respone.text();

                if (text === '"ok"') {
                    props.notifiesRef?.triggerAlert('success', $t('notifies.account.withdraw.success', {amount: amount.value}));
                } else if (text === '"not_enough_money"') {
                    props.notifiesRef?.triggerAlert('warning', $t('notifies.account.withdraw.not_enough_money'));
                } else if (text === '"error"') {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.account.withdraw.error'));
                } else if (text === '"unknown_error"') {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.account.withdraw.unknown_error'));
                } else {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.account.withdraw.unknown'));
                }

                } catch (error) {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.account.withdraw.nui_error', {error: error.message}));
                }
        } else {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.account.withdraw.invalid_amount'));
        }

        document.getElementById('amount').value = '';
    }
</script>


<template>
    <div class="account-container">
        <h1 class="text-start">{{ $t('pages.account') }}</h1>
        <hr />

        <div class="info-section">
            <h4>{{ $t('account.balance') }} <span class="badge text-bg-primary">{{ account }}</span></h4>

            <div class="input-group mb-3">
                <span class="input-group-text">
                    <i v-if="currency === '$'" class="bi bi-currency-dollar"></i>
                    <i v-else-if="currency === '€'" class="bi bi-currency-euro"></i>
                    <i v-else-if="currency === '£'" class="bi bi-currency-pound"></i>
                    <i v-else-if="currency === '¥'" class="bi bi-currency-yen"></i>
                    <i v-else-if="currency === '₹'" class="bi bi-currency-rupee"></i>
                    <i v-else class="bi bi-cash"></i>
                    <span v-else>{{ currency }}</span>
                </span>
                <input id="amount" type="number" class="form-control" :placeholder="$t('account.placeholder')" aria-label="Amount" min="1">
                <span class="input-group-text">.00</span>

                <button class="btn btn-primary" @click="deposit()">{{ $t('buttons.deposit') }}</button>
                <button class="btn btn-primary" @click="withdraw()">{{ $t('buttons.withdraw') }}</button>
            </div>

            <h4 class="mt-3">{{ $t('account.last_transactions') }}
                <button class="btn btn-primary" @click="$emit('see-all-transactions')"
                    style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .6rem;">{{ $t('buttons.see_all') }}
                </button>
            </h4>

            <div>
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th style="font-weight: bold;">#</th>
                            <th style="font-weight: bold;">{{ $t('account.table_action') }}</th>
                            <th style="font-weight: bold;">{{ $t('account.table_employee') }}</th>
                            <th style="font-weight: bold;">{{ $t('account.table_amount') }}</th>
                        </tr>
                    </thead>
                    <tbody style="color: #fff;" class="table-group-divider">
                        <tr v-for="(transaction, i) in [...transactions].sort((a, b) => b.id - a.id).slice(0, 5)"
                            :key="i">
                            <td>{{ transaction.id }}</td>
                            <td>{{ transaction.action }}</td>
                            <td>{{ transaction.employee }}</td>
                            <td>{{ transaction.amount }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    h1 {
        font-size: 1.7rem;
        margin-bottom: 20px;
        text-align: center;
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

    .text-bg-primary {
        background-color: var(--color-500) !important;
        color: #fff !important;
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