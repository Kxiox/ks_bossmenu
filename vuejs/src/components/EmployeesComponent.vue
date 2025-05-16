<template>
    <h1 class="text-start">Employees</h1>

    <hr>

    <div style="overflow-x: auto; overflow-y: auto; max-height: 41vh; max-width: 100%; min-width: 100%;">
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
                            <!-- <tr v-for="employee in employees" :key="employee.id">
                <td>{{ employee.id }}</td>
                <td>{{ employee.name }}</td>
                <td>{{ employee.position }}</td>
                <td>{{ employee.salary }}</td>
                <td><button @click="editEmployee(employee.id)">Edit</button></td>
            </tr> -->
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
                </tr>
                <tr>
                    <td>John Doe</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Promote</button><button class="btn btn-sm btn-blue" @click="">Demote</button><button class="btn btn-sm btn-danger" @click="">Fire</button></td>
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

        .btn-blue {
            background-color: var(--color-500);
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: var(--color-600);
            }
        }        
    }
</style>