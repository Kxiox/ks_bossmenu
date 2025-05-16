<template>
    <h1 class="text-start">Salaries</h1>

    <hr>

    <div style="overflow-x: auto; overflow-y: auto; max-height: 41vh; max-width: 100%; min-width: 100%;">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th style="font-weight: bold;">ID</th>
                    <th style="font-weight: bold;">Name</th>
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
                    <td>11</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>10</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>9</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>8</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>7</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>6</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>5</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>4</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>3</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>1</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
                </tr>
                <tr>
                    <td>0</td>
                    <td>Manager</td>
                    <td>$5000</td>
                    <td class="buttons"><button class="btn btn-sm btn-blue" @click="">Change</button></td>
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

        .btn-indigo {
            background-color: $indigo-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $indigo-600;
            }
        }

        .btn-purple {
            background-color: $purple-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $purple-600;
            }
        }

        .btn-pink {
            background-color: $pink-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $pink-600;
            }
        }

        .btn-red {
            background-color: $red-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $red-600;
            }
        }

        .btn-orange {
            background-color: $orange-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $orange-600;
            }
        }

        .btn-yellow {
            background-color: $yellow-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $yellow-600;
            }
        }

        .btn-green {
            background-color: $green-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $green-600;
            }
        }

        .btn-teal {
            background-color: $teal-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $teal-600;
            }
        }

        .btn-cyan {
            background-color: $cyan-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $cyan-600;
            }
        }

        .btn-gray {
            background-color: $gray-500;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;

            &:hover {
                background-color: $gray-600;
            }
        }
        
    }
</style>