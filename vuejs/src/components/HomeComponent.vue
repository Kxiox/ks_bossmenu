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

        <h4 class="mt-3">
            Last actions
            <button class="btn btn-primary"
                style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .6rem;"
                @click="$emit('see-all-actions')">
                See all
            </button>
        </h4>

        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th style="font-weight: bold;">#</th>
                    <th style="font-weight: bold;">Action</th>
                    <th style="font-weight: bold;">Employee</th>
                    <th style="font-weight: bold;">Time</th>
                </tr>
            </thead>

            <tbody class="table-group-divider" style="color: #fff;">
                <tr>
                    <td>1</td>
                    <td>Started work</td>
                    <td>John Doe</td>
                    <td>10:00 AM | May 03 2025</td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>Finished work</td>
                    <td>Jane Smith</td>
                    <td>5:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>3</td>
                    <td>Received salary</td>
                    <td>Bob Johnson</td>
                    <td>3:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>4</td>
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