<div id="page-community-members" class="page-content d-none">
    <div class="mb-4">
        <button class="btn btn-outline-primary" onclick="goBackToCommunityDetail()">
            <i class="fas fa-arrow-left me-2"></i>Back
        </button>
    </div>

    <div class="bg-white rounded-xl p-4 shadow-sm">
        <h2 class="mb-4">Community Members</h2>
        <div class="table-container">
            <table class="table">
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Real Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Join Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="communityMembersTableBody">
                </tbody>
            </table>
        </div>

        <nav class="mt-4" aria-label="Page navigation">
            <ul class="pagination justify-content-center" id="communityMembersPagination">
            </ul>
        </nav>
    </div>
</div>
