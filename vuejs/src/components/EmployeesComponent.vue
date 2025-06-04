<script setup>
    defineProps({
        employees: {
            type: Array,
            default: () => []
        }
    })

    function addEmployee() {

    }
</script>

<template>
    <h1 class="text-start">Employees</h1>

    <hr>

    <button class="btn btn-primary mb-3 w-100" data-bs-toggle="modal" data-bs-target="#employeeModal"><i class="bi bi-person-plus-fill"></i> Add Employee</button>

    <div style="overflow-x: auto; overflow-y: auto; max-height: 36vh; max-width: 100%; min-width: 100%;">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th style="font-weight: bold;">Name</th>
                    <th style="font-weight: bold;">Position</th>
                    <th style="font-weight: bold;">Salary</th>
                    <th style="font-weight: bold;">Actions</th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
                <tr v-for="(employee, i) in [...employees].sort((a, b) => b.jobgradenr - a.jobgradenr)" :key="i">
                    <td>{{ employee.firstname }} {{ employee.lastname }}</td>
                    <td>{{ employee.jobgrade }}</td>
                    <td>{{ employee.salary }}</td>
                    <td class="buttons"><button class="btn btn-sm btn-primary" @click="">Promote</button><button class="btn btn-sm btn-primary" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
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