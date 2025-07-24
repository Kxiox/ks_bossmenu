<script setup>
import EmployeeModal from './modals/EmployeeModal.vue'
import SalaryModal from './modals/SalaryModal.vue'
import BonusEmployeesModal from './modals/BonusEmployeesModal.vue'
import BonusRanksModal from './modals/BonusRanksModal.vue'
import BonusAllEmployeesModal from './modals/BonusAllEmployeesModal.vue'
import BonusAllRanksModal from './modals/BonusAllRanksModal.vue'
import BonusOnlineEmployeesModal from './modals/BonusOnlineEmployeesModal.vue'

const props = defineProps({
    notifiesRef: Object,
    selectedSalary: {
        type: Object,
        default: null
    },
    currency: {
        type: String,
        default: null
    },
    employees: {
        type: Array,
        default: () => []
    },
    saleries: {
        type: Array,
        default: () => []
    },
    onlineEmployees: {
        type: Array,
        default: () => []
    }
})
</script>

<template>
    <!-- Employee Management Modal -->
    <EmployeeModal 
        :notifiesRef="notifiesRef"
    />

    <!-- Salary Management Modal -->
    <SalaryModal 
        :notifiesRef="notifiesRef"
        :selectedSalary="selectedSalary"
        :currency="currency"
    />

    <!-- Bonus Modals -->
    <BonusEmployeesModal 
        :notifiesRef="notifiesRef"
        :currency="currency"
        :employees="employees"
    />

    <BonusRanksModal 
        :notifiesRef="notifiesRef"
        :currency="currency"
        :saleries="saleries"
    />

    <BonusAllEmployeesModal 
        :notifiesRef="notifiesRef"
        :currency="currency"
        :employees="employees"
    />

    <BonusAllRanksModal 
        :notifiesRef="notifiesRef"
        :currency="currency"
        :saleries="saleries"
    />

    <BonusOnlineEmployeesModal 
        :notifiesRef="notifiesRef"
        :currency="currency"
        :onlineEmployees="onlineEmployees"
    />
</template>

<style scoped lang="scss">
    @use 'bootstrap/scss/bootstrap' as *;

    /* Ensure input groups work properly in modals */
    .input-group {
        margin-bottom: 0;
    }

    .input-group-text {
        display: flex;
        align-items: center;
        justify-content: center;
        min-width: 45px;
    }

    /* Remove all focus outlines and blue borders */
    * {
        outline: none !important;
        box-shadow: none !important;
    }

    *:focus {
        outline: none !important;
        box-shadow: none !important;
    }

    input:focus,
    textarea:focus,
    select:focus,
    button:focus {
        outline: none !important;
        box-shadow: none !important;
    }

    /* Mobile responsiveness */
    @media (max-width: 768px) {
        .modal-dialog {
            max-width: 95vw;
            min-width: unset;
            margin: 0.5rem;
        }
    }

    ::-webkit-scrollbar {
        width: 0.2rem;
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
    }

    /* Employee Selection Styles */
    .employee-selection-header {
        padding: 0.75rem;
        background: var(--color-750);
        border-radius: 8px;
        border: 1px solid var(--color-600);
    }

    .employee-avatar {
        font-size: 1.5rem;
        color: var(--color-400);
    }

    .employee-name {
        font-weight: 600;
        color: #fff;
    }

    .table-container {
        border-radius: 8px;
        border: 1px solid var(--color-600);
        background: var(--color-800);
        overflow-x: auto !important;
        overflow-y: auto !important;
    }

    /* Custom Scrollbar für die Bonus-Tabelle */
    .table-container::-webkit-scrollbar {
        width: 8px;
        height: 8px;
    }

    .table-container::-webkit-scrollbar-track {
        background: var(--color-800);
        border-radius: 4px;
    }

    .table-container::-webkit-scrollbar-thumb {
        background: var(--color-600);
        border-radius: 4px;
        transition: background 0.2s ease;
    }

    .table-container::-webkit-scrollbar-thumb:hover {
        background: var(--color-500);
    }

    .table-container::-webkit-scrollbar-corner {
        background: var(--color-800);
    }

    .table tr {
        transition: all 0.2s ease;
    }

    .table tr:hover {
        background: var(--color-700) !important;
    }

    .table tr.table-active {
        border-left: 3px solid var(--color-500);
    }

    .table tr.table-active:hover {
        background: var(--color-700) !important;
    }

    .table th {
        background: var(--color-700) !important;
        color: #fff !important;
        border-bottom: 2px solid var(--color-600) !important;
        position: sticky;
        top: 0;
        z-index: 10;
    }

    .table td {
        border-bottom: 1px solid var(--color-700) !important;
        color: #fff !important;
        vertical-align: middle;
    }

    .form-check-input {
        background-color: var(--color-800) !important;
        border: 1px solid var(--color-600) !important;
        border-radius: 4px !important;
        width: 1.2rem !important;
        height: 1.2rem !important;
        cursor: pointer !important;
    }

    .form-check-input:checked {
        background-color: var(--color-500) !important;
        border-color: var(--color-400) !important;
    }

    .form-check-input:focus {
        border-color: var(--color-500) !important;
        box-shadow: 0 0 0 0.2rem rgba(0, 0, 0, 0.25) !important;
    }

    .form-check-input:indeterminate {
        background-color: var(--color-600) !important;
        border-color: var(--color-500) !important;
    }

    .btn:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    .btn-outline-primary {
        border-color: var(--color-600) !important;
        color: var(--color-300) !important;
        background: transparent !important;
    }

    .btn-outline-primary:hover {
        background: var(--color-600) !important;
        border-color: var(--color-500) !important;
        color: #fff !important;
    }

    .badge {
        font-size: 0.75rem;
        padding: 0.375rem 0.75rem;
        border-radius: 6px;
    }

    .bg-secondary {
        background: linear-gradient(135deg, 
            var(--color-600) 0%, 
            var(--color-500) 100%) !important;
    }

    /* Bulk Bonus Modal Styles */
    .alert {
        border-radius: 8px;
        border: 1px solid var(--color-600);
        background: var(--color-750);
        color: #fff;
    }

    .alert-info {
        border-color: #17a2b8;
        background: rgba(23, 162, 184, 0.1);
        color: #17a2b8;
    }

    .alert-warning {
        border-color: #ffc107;
        background: rgba(255, 193, 7, 0.1);
        color: #ffc107;
    }

    .alert-success {
        border-color: #28a745;
        background: rgba(40, 167, 69, 0.1);
        color: #28a745;
    }

    .alert-secondary {
        border-color: var(--color-600);
        background: var(--color-750);
        color: var(--color-300);
    }

    .ranks-preview, .online-employees-preview {
        padding: 0.75rem;
        background: var(--color-800);
        border-radius: 8px;
        border: 1px solid var(--color-600);
    }

    .ranks-preview h6, .online-employees-preview h6 {
        color: var(--color-300);
        margin-bottom: 0.5rem;
        font-size: 0.875rem;
    }

    .ranks-list, .employees-list {
        display: flex;
        flex-wrap: wrap;
        gap: 0.25rem;
    }

    .employee-badge .badge {
        font-size: 0.75rem;
        padding: 0.375rem 0.75rem;
    }

    .badge.bg-success {
        background: #28a745 !important;
    }

    .badge.bg-secondary {
        background: var(--color-600) !important;
    }
</style>