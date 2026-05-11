<div id="page-profile" class="page-content d-none">
    <h2 class="mb-4">Profile Settings</h2>
    <div class="bg-white rounded-xl p-6 max-w-2xl mx-auto">
        <form id="profileForm">
            <div class="mb-4">
                <label class="form-label font-medium">Username</label>
                <input type="text" class="form-control" id="profileUsername" readonly>
            </div>
            <div class="mb-4">
                <label class="form-label font-medium">Email</label>
                <input type="email" class="form-control" id="profileEmail">
            </div>
            <div class="mb-4">
                <label class="form-label font-medium">Phone</label>
                <input type="text" class="form-control" id="profilePhone" placeholder="Enter phone number">
            </div>
            <div class="mb-4">
                <label class="form-label font-medium">Real Name</label>
                <input type="text" class="form-control" id="profileRealName" placeholder="Enter real name">
            </div>
            <div class="d-flex gap-3">
                <button type="button" class="btn btn-secondary" onclick="showPage('home')">Cancel</button>
                <button type="submit" class="btn btn-primary ms-auto">Update Profile</button>
            </div>
        </form>
    </div>
</div>