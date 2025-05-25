<template>
    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="#" @click.prevent="$emit('back-to-home')" class="back-btn"><i class="bi bi-arrow-left"></i></a>
        <h1 class="text-start" style="margin: 0;">Home</h1>
    </div>

    <hr>

    <h4>All Actions</h4>
    <div style="overflow-x: auto; overflow-y: auto; max-height: 37vh; max-width: 100%; min-width: 100%;">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th><b>#</b></th>
                    <th><b>Action</b></th>
                    <th><b>Employee</b></th>
                    <th><b>Time</b></th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
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
                    <td>Started work</td>
                    <td>John Doe</td>
                    <td>10:00 AM | May 03 2025</td>
                </tr>
                <tr>
                    <td>5</td>
                    <td>Finished work</td>
                    <td>Jane Smith</td>
                    <td>5:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>6</td>
                    <td>Received salary</td>
                    <td>Bob Johnson</td>
                    <td>3:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>7</td>
                    <td>Started work</td>
                    <td>John Doe</td>
                    <td>10:00 AM | May 03 2025</td>
                </tr>
                <tr>
                    <td>8</td>
                    <td>Finished work</td>
                    <td>Jane Smith</td>
                    <td>5:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>9</td>
                    <td>Received salary</td>
                    <td>Bob Johnson</td>
                    <td>3:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>10</td>
                    <td>Started work</td>
                    <td>John Doe</td>
                    <td>10:00 AM | May 03 2025</td>
                </tr>
                <tr>
                    <td>11</td>
                    <td>Finished work</td>
                    <td>Jane Smith</td>
                    <td>5:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>12</td>
                    <td>Received salary</td>
                    <td>Bob Johnson</td>
                    <td>3:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>13</td>
                    <td>Started work</td>
                    <td>John Doe</td>
                    <td>10:00 AM | May 03 2025</td>
                </tr>
                <tr>
                    <td>14</td>
                    <td>Finished work</td>
                    <td>Jane Smith</td>
                    <td>5:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>15</td>
                    <td>Received salary</td>
                    <td>Bob Johnson</td>
                    <td>3:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>16</td>
                    <td>Started work</td>
                    <td>John Doe</td>
                    <td>10:00 AM | May 03 2025</td>
                </tr>
                <tr>
                    <td>17</td>
                    <td>Finished work</td>
                    <td>Jane Smith</td>
                    <td>5:00 PM | May 02 2025</td>
                </tr>
                <tr>
                    <td>18</td>
                    <td>Received salary</td>
                    <td>Bob Johnson</td>
                    <td>3:00 PM | May 02 2025</td>
                </tr>
                <!-- Weitere Aktionen -->
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
