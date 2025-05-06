<template>
    <h1 class="text-start">Home</h1>

    <hr>

    <div class="info-section">
        <h4>Stats</h4>
        <div class="row">
            <div class="col">
                <div class="stats-section">
                    <div class="container">
                        <div class="row g-0">
                            <div class="col-6 col-md-4">
                                <i class="bi bi-people" style="font-size: 225%;"></i>
                            </div>

                            <div class="col-sm-6 col-md-8">
                                <h5>Employees:</h5>
                                <h6>100</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col">
                <div class="stats-section">
                    <div class="container">
                        <div class="row g-0">
                            <div class="col-6 col-md-4">
                                <i class="bi bi-person-check" style="font-size: 225%;"></i>
                            </div>
                            <div class="col-sm-6 col-md-8">
                                <h5>On Duty:</h5>
                                <h6>20</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col">
                <div class="stats-section">
                    <div class="container">
                        <div class="row g-0">
                            <div class="col-6 col-md-4">
                                <i class="bi bi-bank" style="font-size: 225%;"></i>
                            </div>

                            <div class="col-sm-6 col-md-8">
                                <h5>Account:</h5>
                                <h6>4.331.344.333€</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <h4 class="mt-3">Last actions <button class="btn" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .6rem;">See all</button></h4>

        <table class="table table-blue table-striped table-hover">
            <thead>
                <tr>
                    <th scope="col" style="font-weight: bold; color: #007bff;">Action</th>
                    <th scope="col" style="font-weight: bold; color: #007bff;">Employee</th>
                    <th scope="col" style="font-weight: bold; color: #007bff;">Time</th>
                </tr>
            </thead>

            <tbody class="table-group-divider">
                <tr>
                    <td>Started work</td>
                    <td>John Doe</td>
                    <td>10:00 AM | May 03 2025</td>
                </tr>
                <tr>
                    <td>Finished work</td>
                    <td>Jane Smith</td>
                    <td>5:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>Received salary</td>
                    <td>Bob Johnson</td>
                    <td>3:00 PM | May 02 2025</td>
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

        .btn {
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
</style>