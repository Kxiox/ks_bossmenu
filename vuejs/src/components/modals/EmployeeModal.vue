<script setup>
    import { useTranslations } from '../../composables/useTranslations.js'

    const { translationsReady, $t } = useTranslations()

    const props = defineProps({
        notifiesRef: Object
    })

    async function addEmployee() {
        const targetId = parseInt(document.getElementById('targetId').value);

        if (targetId && targetId > 0) {
            try {
                const response = await fetch(`https://${GetParentResourceName()}/addEmployee`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8'
                    },
                    body: JSON.stringify({
                        message: targetId
                    })
                });
                const text = await response.text();

                if (text === '"ok"') {
                    props.notifiesRef?.triggerAlert('success', $t('notifies.employees.add.success', { id: targetId }));
                } else {
                    props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.add.failed'));
                }
            } catch (error) {
                props.notifiesRef?.triggerAlert('danger', $t('notifies.employees.add.nui_error', { error: error.message }));
            }
        } else {
            props.notifiesRef?.triggerAlert('warning', $t('notifies.employees.add.invalid_id'));
        }

        document.getElementById('targetId').value = '';
    }
</script>

<template>
    <div class="modal fade" id="employeeModal" tabindex="-1" aria-labelledby="employeeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div v-if="!translationsReady" class="modal-body text-center">
                    <div class="spinner-border" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Lade Übersetzungen...</p>
                </div>
                <template v-else>
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="employeeModalLabel">
                            <i class="bi bi-person-plus-fill"></i> {{ $t('employees.add_employee') }}
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                            <input id="targetId" type="number" class="form-control" placeholder="ID" aria-label="ID" min="1">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-second" data-bs-dismiss="modal">{{ $t('buttons.cancel') }}</button>
                        <button type="button" class="btn btn-main" data-bs-dismiss="modal" @click="addEmployee()">{{ $t('buttons.add') }}</button>
                    </div>
                </template>
            </div>
        </div>
    </div>
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    .input-group {
        margin-bottom: 0;
    }

    .input-group-text {
        display: flex;
        align-items: center;
        justify-content: center;
        min-width: 45px;
    }

    * {
        outline: none !important;
        box-shadow: none !important;
    }

    *:focus {
        outline: none !important;
        box-shadow: none !important;
    }

    @media (max-width: 768px) {
        .modal-dialog {
            max-width: 95vw;
            min-width: unset;
            margin: 0.5rem;
        }
    }
</style>
