<%-- Staff Navbar fragment: do NOT add a page directive here to avoid conflicts when included --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="${ctx}/assets/css/navbar.css?v=1" />
<script src="${ctx}/assets/js/navbar.js?v=1" defer></script>

<nav class="staff-navbar" role="navigation" aria-label="Staff navigation">
  <div class="staff-brand">
    <a href="${ctx}/staff/staffpanel.jsp" class="staff-brand-link" style="text-decoration:none; color:inherit;" aria-label="Pahana Edu Staff Home">
      <img src="${ctx}/assets/img/logo.png" alt="Pahana Edu" class="staff-logo" />
      <span>Pahana Edu : Staff</span>
    </a>
  </div>

  <div class="staff-links">
    <a href="${ctx}/staff/staffpanel.jsp"
       class="<c:if test='${activePage == "dashboard"}'>active-link</c:if>">Dashboard</a>

    <a href="${ctx}/manage-books"
       class="<c:if test='${activePage == "checkout"}'>active-link</c:if>">Manage Books</a>

    <a href="${ctx}/staff/manage_users.jsp"
       class="<c:if test='${activePage == "checkout"}'>active-link</c:if>">Manage Users</a>

    <a href="${ctx}/staff/manage-categories"
       class="<c:if test='${activePage == "checkout"}'>active-link</c:if>">Manage Categories</a>

    <a href="${ctx}/staff/checkout.jsp"
       class="<c:if test='${activePage == "checkout"}'>active-link</c:if>">Checkout</a>




    <span class="staff-user">
      <c:choose>
        <c:when test="${not empty sessionScope.staffName}">
          Signed in as: ${sessionScope.staffName}
        </c:when>
        <c:when test="${not empty sessionScope.userName}">
          Signed in as: ${sessionScope.userName}
        </c:when>
        <c:when test="${not empty sessionScope.username}">
          Signed in as: ${sessionScope.username}
        </c:when>
        <c:otherwise>
          Signed in
        </c:otherwise>
      </c:choose>
    </span>

    <a href="${ctx}/logout.jsp" style="margin-left:auto;">Logout</a>
  </div>
</nav>